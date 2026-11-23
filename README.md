Nama: Lavida Yuthiana Faizah
NPM: 2506605941
Kelas: PBP E

# PROGRES MINGGUAN
- Tutor 8 --> Basic Flutter: Setup proyek, pisah menu.dart, InfoCard, ItemCard, SnackBar.
- TI 7 --> Basic Flutter: Data profil asli, 3 tombol aksi dengan warna berbeda, SnackBar per tombol.

### Tugas 7
1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan parent-child bekerja antar widget!
--> Seluruh tampilan dibangun dari widget yang saling bersarang dan membentuk struktur pohon (widget tree). Root-nya di proyek ini adalah [MyApp] -> [MaterialApp] -> [Scaffold] -> [AppBar] dan [Padding] -> [Column] -> [Row] (berisi [InfoCard]) dan [GridView] (berisi [IteCard]), dan seterusnya. Hubungan parent-child bekerja seperti ini:
    - Parent menentukan constraint (batas ukuran) dan posisi child. Misalnya [Padding] memberi jarak, [Row] menyusun child-nya secara horizontal, [Column] secara vertikal.
    - Child memilih ukurannya sendiri di dalam batas itu, lalu melaporkannya ke parent ("constraints go down, sizes go up, parent sets position").
    - Data mengalir dari atas ke bawah. Contohnya [MyHomePage] mengirim [npm], [nama], [kelas] ke [InfoCard] lewat constructor, dan [ItemHomepage] dikirim ke [ItemCard].
    - Widget di bawah bisa mengakses data dari ancestor-nya lewat [BuildContext], misalnya [Theme.of(context)] mengambil tema dari [MaterialApp].

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!
--> 
- [MyApp] = Root widget aplikasi (StatelessWidget) yang membungkus MaterialApp.
- [MaterialApp] = Menyediakan tema, navigasi, judul aplikasi, dan konfigurasi Material Design.
- [MyHomePage] = Halaman utama (StatelessWidget) di [menu.dart].
- [Scaffold] = 	Kerangka halaman: menyediakan slot [appBar], [body], dan tempat [SnackBar] muncul.
- [AppBar] = Bar judul di bagian atas halaman.
- [Text] = Menampilkan teks.
- [Padding] = Memberi jarak di sekeliling child.
- [Column] = Menyusun child secara vertiikal
- [Row] = 	Menyusun child secara horizontal (dipakai untuk 3 [InfoCard]).
- [SizedBox] = Memberi jarak kosong dengan ukuran tertentu.
- [Center] = Menempatkan child di tengah.
- [GridView.count] = Menampilkan [ItemCard] dalam kisi dengan jumlah kolom tetap (3).
- [InfoCard] = Widget custom untuk kartu informasi, NPM, Name, dan Class.
- [Card] = Kartu bergaya Material dengan bayangan (elevation), dipakai di [InfoCard].
- [Container] = Mengatur lebar dan padding isi kartu.
- [ItemCard] = Widget custom untuk tombol aksi (Lihat Proyek, Tambah Proyek, Logout).
- [Material] = Memberi warna latar dan sudut membulat pada [ItemCard], sekaligus permukaan untuk efek ripple.
- [InkWell] = Membuat area bisa ditekan ([onTap]) dengan efek ripple.
- [Icon] = Menampilkan ikon pada tombol.
- [ScaffoldMessenger] = Mengelola tampilan SnackBar ([hideCurrentSnackBar], [showSnackBar]).
- [SnackBar] = Pesan singkat di bawah layar: "Kamu telah menekan tombol ...!".
[ItemHomePage] bukan widget, melainkan class model data yang menyimpan [name], [icon], dan [color] setiap tombol.

3. Apa fungsi dari widget [MaterialApp]? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!
--> [MaterialApp] adalah widget pembungkus yang menyiapkan semua yang dibutuhkan aplikasi bergaya Material Design: theme (warna dan font global), title, home (halaman pertama), sistem navigasi (Navigator dan route), lokalisasi, serta ScaffoldMessenger untuk SnackBar. Widget ini diletakkan di root karena banyak widget di bawahnya bergantung pada apa yang disediakannya. Scaffold, AppBar, dan Theme.of(context) membutuhkan ancestor MaterialApp agar bisa bekerja. Dengan menaruhnya paling atas, semua halaman otomatis mendapat tema dan navigasi yang sama tanpa perlu dikonfigurasi ulang

4. Jelaskan perbedaan antara [StatelessWidget] dan [StatefulWidget]! Kapan kita sebaiknya memilih [StatelessWidget] dan kapan harus menggunakan [StatefulWidget]?
-->
- [StatelessWidget] tidak punya state yang bisa berubah. Tampilannya hanya bergantung pada data yang diterima lewat constructor. Widget ini hanya dibangun ulang kalau parent-nya membangun ulang dengan data baru.
- [StatefulWidget] punya objek [State] terpisah yang menyimpan data yang bisa berubah selama widget hidup. Saat data berubah dan [setState()] dipanggil, Flutter menjalankan [build()] lagi sehingga UI ikut diperbarui.

Pilih [StatelessWidget] jika tampilan statis atau hanya menampilkan data dari luar, seperti [InfoCard], [ItemCard], dan [MyHomePage] di proyek ini. Pilih [StatefulWidget] jika widget perlu mengingat dan mengubah data sendiri, misalnya counter, isi form/TextField, checkbox, animasi, atau data hasil fetch dari API.

5. Apa itu [BuildContext] dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode [build]?
--> BuildContext [BuildContext] adalah "alamat" atau posisi sebuah widget di dalam widget tree. Setiap metode build(BuildContext context) menerima context miliknya sendiri. Context ini penting karena dipakai untuk mencari dan mengakses widget atau data milik ancestor di atasnya. Contoh penggunaan di proyek ini:
    - [Theme.of(context).colorScheme.primary] mengambil warna dari tema [MaterialApp] untuk [AppBar].
    - [MediaQuery.of(context).size.width] mengambil lebar layar untuk menentukan lebar [InfoCard].
    - [ScaffoldMessenger.of(context).showSnackBar(...)] mencari [ScaffoldMessenger] terdekat untuk menampilkan [SnackBar].
Karena pencarian dilakukan ke atas dari posisi context, context yang dipakai harus berada di bawah widget yang dicari.

6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?
--> 
- Hot reload ([r] di terminal, atau tombol petir di IDE) menyuntikkan kode yang diubah ke Dart VM yang sedang berjalan, lalu membangun ulang widget tree. State dipertahankan dan prosesnya sangat cepat. Cocok untuk mengubah UI seperti warna, teks, atau layout.
- Hot restart ([R]) memuat ulang seluruh kode dan menjalankan aplikasi dari awal ([main()] dipanggil lagi). State hilang, tetapi tetap lebih cepat daripada build ulang penuh.
- Full restart (stop lalu flutter run lagi) membangun ulang aplikasi native secara penuh.

Hot reload saja tidak cukup ketika:
- Mengubah isi [main()] atau [initState()], karena keduanya tidak dijalankan ulang oleh hot reload.
- Mengubah variabel global atau field [static]/[final] yang sudah terinisialisasi.
- Mengubah struktur class, misalnya [StatelessWidget] menjadi [StatefulWidget], menambah field baru ke model, atau mengubah enum/generic.
- Menambah package baru di [pubspec.yaml], aset baru, atau kode native (Android/iOS). Kasus ini butuh full restart atau build ulang.

# AI DISCLOSURE TI 7
- Tools: Claude (Anthropic)
- Saya menggunakan Claude meminta penjelasan langkah pengerjaan Tugas 7 dan konsep Flutter. Saya melampirkan soal tugas untuk meminta penjelasan step by step beserta alasannya, bukan hanya kode jadi. Dari output tersebut saya memahami penjelasan dan mengetik kode sendiri, memilih ikon dan warna, dan menguji aplikasi di emulator. AI tidak bisa menjalankan flutter analyze atau run program untuk cek hasil, jadi hasilnya saya cek sendiri melalui chrome.
- Link Prompting: https://claude.ai/share/d5792607-e992-4256-8a69-3f7f3555298d

### Tugas 8
1. Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.