import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Field mengikuti ExperienceSerializer Django (/api/v1/experiences/).
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _startedAtController = TextEditingController();
  final _endedAtController = TextEditingController();

  String _category = 'full-time';
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _startedAtController.dispose();
    _endedAtController.dispose();
    super.dispose();
  }

  static bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    return null;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startedAt : _endedAt) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startedAt = picked;
        _startedAtController.text = _formatDate(picked);
      } else {
        _endedAt = picked;
        _endedAtController.text = _formatDate(picked);
      }
    });
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    _startedAtController.clear();
    _endedAtController.clear();
    setState(() {
      _category = 'full-time';
      _startedAt = null;
      _endedAt = null;
    });
  }

  /// Tanggal dikirim sebagai tengah malam UTC agar Django (USE_TZ=True)
  /// menerima datetime ber-timezone.
  static DateTime? _toUtcDate(DateTime? date) =>
      date == null ? null : DateTime.utc(date.year, date.month, date.day);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Pastikan sudah login sebelum mengirim POST terautentikasi.
    final allowed = await ensureLoggedIn(context);
    if (!allowed || !mounted) return;

    final auth = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final token = auth.token;
    if (token == null) return;

    final newProject = Project(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      thumbnail: _thumbnailController.text.trim(),
      startedAt: _toUtcDate(_startedAt),
      endedAt: _toUtcDate(_endedAt),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await apiClient.createProject(newProject, token: token);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${created.title}'),
                Text('Description: ${created.description}'),
                Text('Category: ${created.categoryLabel}'),
                if (created.thumbnail.isNotEmpty)
                  Text('Thumbnail: ${created.thumbnail}'),
                Text(
                  'Started: ${created.startedAt == null ? '-' : _formatDate(created.startedAt!.toLocal())}',
                ),
                Text(
                  'Ended: ${created.endedAt == null ? 'Masih berjalan' : _formatDate(created.endedAt!.toLocal())}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      if (!mounted) return;
      _resetForm();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Token tidak valid/kedaluwarsa: logout lalu minta login ulang.
        await auth.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi berakhir. Silakan login ulang.')),
        );
        await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hanya pemilik portofolio yang bisa menambah.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan proyek (${e.statusCode}).')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint ?? label,
      labelText: label,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: _decoration('Title'),
                  validator: (value) => _requiredValidator(value, 'Title'),
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: _decoration('Description'),
                  validator: (value) =>
                      _requiredValidator(value, 'Description'),
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration('Category'),
                  initialValue: _category,
                  items: Project.categories.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _category = value;
                    });
                  },
                ),
              ),

              // === Thumbnail URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _thumbnailController,
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    'Thumbnail URL (Optional)',
                    hint: 'https://example.com/gambar.png',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isNotEmpty && !_isValidUrl(text)) {
                      return 'Masukkan URL yang valid (http/https)!';
                    }
                    return null;
                  },
                ),
              ),

              // === Started at (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedAtController,
                  readOnly: true,
                  decoration: _decoration(
                    'Started at (Optional)',
                    hint: 'Pilih tanggal mulai',
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: true),
                ),
              ),

              // === Ended at (opsional, kosong = masih berjalan) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedAtController,
                  readOnly: true,
                  decoration: _decoration(
                    'Ended at (Optional)',
                    hint: 'Kosongkan jika masih berjalan',
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (_) {
                    if (_startedAt != null &&
                        _endedAt != null &&
                        _endedAt!.isBefore(_startedAt!)) {
                      return 'Tanggal selesai harus setelah tanggal mulai!';
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
