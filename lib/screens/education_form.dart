import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _institution = "";
  String _degree = "S1";
  String _major = "";

  final List<String> _degrees = ['SMA/SMK', 'D3', 'D4', 'S1', 'S2', 'S3'];

  // Controller untuk menampilkan teks tanggal di kolom (diisi dari kalender).
  final _startDateController = TextEditingController();
  DateTime? _startDate;

  final _endDateController = TextEditingController();
  DateTime? _endDate;
  bool _isOngoing = false;

  String _gpa = "";
  String _description = "";

  static const int _maxDescriptionLength = 300;

  @override
  void dispose() {
    // Membersihkan controller saat halaman ditutup agar tidak bocor memori.
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  static const int _maxNameLength = 100;

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  /// Validator IPK: opsional, tapi jika diisi harus angka 0.00 - 4.00.
  String? _validateGpa(String? value) {
    // Boleh kosong karena IPK opsional (misalnya untuk jenjang SMA).
    if (value == null || value.trim().isEmpty) return null;
    // Terima koma (3,75) maupun titik (3.75).
    final gpa = double.tryParse(value.trim().replaceAll(',', '.'));
    if (gpa == null) {
      return "IPK harus berupa angka, misalnya 3.75";
    }
    if (gpa < 0 || gpa > 4) {
      return "IPK harus di antara 0.00 dan 4.00!";
    }
    return null;
  }

  String? _validateRequiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName tidak boleh kosong!";
    }
    if (value.trim().length > _maxNameLength) {
      return "$fieldName maksimal $_maxNameLength karakter!";
    }
    return null;
  }

  /// Mengubah DateTime menjadi teks "dd/mm/yyyy".
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Membuka kalender dan menyimpan tanggal yang dipilih.
  /// isStart = true untuk Tanggal Mulai, false untuk Tanggal Selesai.
  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    // Pengguna menekan Cancel, tanggal lama tidak diubah.
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  /// Menampilkan ringkasan isian setelah semua input lolos validasi.
  void _showSummaryDialog() {
    // Jika masih berjalan, tanggal selesai memang kosong.
    final endText = _isOngoing ? 'Masih berjalan' : _formatDate(_endDate!);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edukasi berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${_institution.trim()}'),
                Text('Jenjang: $_degree'),
                Text('Jurusan: ${_major.trim()}'),
                Text('Mulai: ${_formatDate(_startDate!)}'),
                Text('Selesai: $endText'),
                Text('IPK: ${_gpa.trim().isEmpty ? '-' : _gpa.trim()}'),
                Text(
                  'Deskripsi: ${_description.trim().isEmpty ? '-' : _description.trim()}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              // Menutup dialog dan kembali ke formulir.
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Education Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === Institusi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "Nama Institusi",
                    hint: "Contoh: Universitas Indonesia",
                  ),
                  maxLength: _maxNameLength,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setState(() => _institution = value),
                  validator: (value) =>
                      _validateRequiredText(value, "Nama institusi"),
                ),
              ),
              // === Jenjang ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration("Jenjang Pendidikan"),
                  initialValue: _degree,
                  items: _degrees
                      .map(
                        (degree) => DropdownMenuItem(
                          value: degree,
                          child: Text(degree),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _degree = value!),
                ),
              ),

              // === Jurusan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "Jurusan / Program Studi",
                    hint: "Contoh: Ilmu Komputer",
                  ),
                  maxLength: _maxNameLength,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setState(() => _major = value),
                  validator: (value) => _validateRequiredText(value, "Jurusan"),
                ),
              ),

              // === Tanggal Mulai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startDateController,
                  // readOnly: tidak bisa diketik, diisi lewat kalender.
                  readOnly: true,
                  decoration: _decoration(
                    "Tanggal Mulai",
                    hint: "Pilih tanggal",
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (_) {
                    if (_startDate == null) {
                      return "Tanggal mulai wajib dipilih!";
                    }
                    if (_startDate!.isAfter(DateTime.now())) {
                      return "Tanggal mulai tidak boleh di masa depan!";
                    }
                    return null;
                  },
                ),
              ),

              // === Masih berjalan? ===
              SwitchListTile(
                title: const Text("Masih berjalan"),
                value: _isOngoing,
                onChanged: (value) {
                  setState(() {
                    _isOngoing = value;
                    // Jika masih berjalan, hapus tanggal selesai yang lama.
                    if (value) {
                      _endDate = null;
                      _endDateController.clear();
                    }
                  });
                },
              ),

              // === Tanggal Selesai (disembunyikan jika masih berjalan) ===
              if (!_isOngoing)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: _decoration(
                      "Tanggal Selesai",
                      hint: "Pilih tanggal",
                      suffix: const Icon(Icons.event),
                    ),
                    onTap: () => _pickDate(isStart: false),
                    validator: (_) {
                      if (_endDate == null) {
                        return "Tanggal selesai wajib dipilih (atau aktifkan Masih berjalan)!";
                      }
                      // Validasi urutan tanggal.
                      if (_startDate != null &&
                          !_endDate!.isAfter(_startDate!)) {
                        return "Tanggal selesai harus setelah tanggal mulai!";
                      }
                      return null;
                    },
                  ),
                ),

              // === IPK (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "IPK (opsional)",
                    hint: "Contoh: 3.75",
                  ),
                  // Keyboard angka dengan titik desimal di HP.
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setState(() => _gpa = value),
                  validator: _validateGpa,
                ),
              ),

              // === Deskripsi (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  maxLength: _maxDescriptionLength,
                  decoration: _decoration(
                    "Deskripsi (opsional)",
                    hint: "Kegiatan, prestasi, atau mata kuliah favorit",
                  ),
                  onChanged: (value) => setState(() => _description = value),
                  validator: (value) {
                    if (value != null &&
                        value.trim().length > _maxDescriptionLength) {
                      return "Deskripsi maksimal $_maxDescriptionLength karakter!";
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 8.0),

              // === Tombol Simpan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                  onPressed: () {
                    // validate() menjalankan semua validator di dalam Form.
                    // Dialog hanya muncul jika semua input valid.
                    if (_formKey.currentState!.validate()) {
                      _showSummaryDialog();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
