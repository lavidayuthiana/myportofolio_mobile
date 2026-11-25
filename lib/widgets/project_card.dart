import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _handleTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    // Menampilkan SnackBar dengan pesan interaktif.
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
      );

    if (item.name == "Lihat Proyek") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProjectListPage()),
      );
    } else if (item.name == "Tambah Proyek") {
      // Aksi terproteksi: arahkan ke login jika belum login.
      final allowed = await ensureLoggedIn(context);
      if (!allowed || !context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProjectFormPage()),
      );
    } else if (item.name == "Tambah Edukasi") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EducationFormPage()),
      );
    } else if (item.name == "Logout") {
      final auth = context.read<AuthState>();
      if (!auth.isLoggedIn) return;
      await auth.logout();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Kamu berhasil logout.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // Warna latar diambil dari model, jadi setiap tombol punya warna sendiri.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
