Nama: Lavida Yuthiana Faizah
NPM: 2506605941
Kelas: PBP E

# PROGRES MINGGUAN
- Tutor 8 --> Basic Flutter: Setup proyek, pisah menu.dart, InfoCard, ItemCard, SnackBar.
- TI 7 --> Basic Flutter: Data profil asli, 3 tombol aksi dengan warna berbeda, SnackBar per tombol.
- Tutor 9 --> Navigasi, layout, form: LeftDrawer, ProjectFormPage, refactor ke lib/screens/ dan lib/widgets/.
- TI 8 --> Formulir Edukasi (EducationFormPage) dengan date picker dan validasi, kartu "Tambah Edukasi", opsi "Add Education" di drawer, dialog ringkasan, dan halaman utama yang bisa digulir.

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
1. Jelaskan perbedaan antara [Navigator.push()], [Navigator.pushReplacement()], dan [Navigator.pop()]. Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.
--> Navigator menyimpan halaman dalam bentuk stack.
    - [Navigator.push()] menaruh halaman baru di atas stack. Halaman lama tetap ada di bawahnya, jadi pengguna bisa kembali dengan tombol back.
    - [Navigator.pushReplacement()] mengganti halaman paling atas dengan halaman baru. Halaman lama dibuang dari stack, jadi tombol back tidak membawa ke halaman itu lagi.
    - [Navigator.pop()] membuang halaman paling atas sehingga pengguna kembali ke halaman di bawahnya. Di proyek ini [pop()] juga dipakai untuk menutup [AlertDialog], karena dialog juga sebuah route.

Kartu "Tambah Edukasi" di [ItemCard] memakai [Navigator.push()], sehingga stack menjadi [MyHomePage] -> [EducationFormPage] dan tombol back membawa pengguna kembali ke halaman utama. Opsi Home di [LeftDrawer] memakai [Navigator.pushReplacement()] ke [MyHomePage()]. Halaman formulir yang sedang terbuka diganti dengan halaman utama, jadi stack tidak terus bertambah setiap kali berpindah lewat drawer.

2. Bagaimana susunan [Scaffold], [AppBar], dan [Drawer] membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.
--> [Scaffold] memberi kerangka yang sama untuk setiap halaman: [appBar] di atas, [drawer] di samping, dan [body] untuk isi. [MyHomePage], [ProjectFormPage], dan [EducationFormPage] sama-sama memakai [Scaffold] dengan [AppBar] dan [drawer: const LeftDrawer()], jadi judul halaman dan menu navigasi selalu ada di posisi yang sama. [LeftDrawer] cukup ditulis sekali di [lib/widgets/] lalu dipakai ulang, sehingga saat saya menambah opsi "Add Education", semua halaman langsung ikut berubah.

Contoh warna tema: [MaterialApp] memakai [ColorScheme.fromSeed(seedColor: Colors.indigo)]. Warna [Theme.of(context).colorScheme.primary] dipakai untuk [AppBar] di halaman utama dan juga untuk [AppBar] serta tombol Simpan di [EducationFormPage]. Kalau seed color diganti, kedua halaman ikut berubah.

3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.
--> Formulir Edukasi disusun dalam satu [Column] vertikal dengan [CrossAxisAlignment.stretch], sehingga setiap input memakai lebar penuh dan urutannya mengikuti urutan pengisian (institusi -> jenjang -> jurusan -> tanggal -> IPK -> deskripsi -> Simpan). Tata letak satu kolom paling mudah dibaca di layar ponsel, dan tombol Simpan dibuat selebar layar supaya mudah ditekan.
    - Widget pengatur jarak: [Padding] 8 px di setiap input dan [SizedBox] sebelum tombol memberi ruang supaya kolom dan pesan error tidak saling menempel.
    - Widget penggulir: [SingleChildScrollView] membungkus [Column]. Saat layar pendek atau keyboard muncul, ruang tampilan berkurang. Tanpa penggulir, [Column] akan overflow dan tombol Simpan tidak terjangkau.

Saya juga mengalami ini di halaman utama. Setelah menambah kartu keempat, [GridView] 3 kolom menjadi 2 baris dan muncul "BOTTOM OVERFLOWED BY 294 PIXELS" karena body hanya berupa [Column] yang tidak bisa digulir. Saya membungkusnya dengan [SingleChildScrollView] dan mengatur [GridView] dengan [primary: false] dan [NeverScrollableScrollPhysics()] supaya hanya ada satu penggulir.

4. Apa peran [GlobalKey<FormState>], [validator], dan [validate()] saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.
--> [GlobalKey<FormState>] ([_formKey]) dipasang pada [Form] supaya state formulir bisa diakses dari tombol Simpan. Setiap input punya [validator] yang mengembalikan [null] jika valid atau teks error jika tidak. Saat Simpan ditekan, [_formKey.currentState!.validate()] menjalankan semua validator. Jika ada yang mengembalikan teks, pesan error tampil di kolom terkait dan [validate()] bernilai [false], jadi dialog tidak muncul. [AlertDialog] ringkasan hanya ditampilkan jika hasilnya [true].

Contoh nilai yang ditolak: IPK "4.5" ditolak dengan pesan "IPK harus di antara 0.00 dan 4.00!". Kolom IPK sudah memakai [TextInputType.numberWithOptions(decimal: true)], tetapi keyboard angka hanya memudahkan pengguna, tidak membatasi nilai. Pengguna tetap bisa mengetik angka di luar rentang, "3..5", atau menempelkan teks, dan di Chrome keyboard laptop bisa mengetik huruf apa saja. Contoh lain: nama institusi yang hanya berisi spasi ditolak lewat [trim()], dan tanggal selesai yang lebih awal dari tanggal mulai ditolak walaupun keduanya dipilih lewat [showDatePicker()]. Jadi aturan model tetap harus dicek di [validator].

# AI DISCLOSURE TI 8
- Tools: Claude (Anthropic)
- Saya menggunakan Claude untuk meminta penjelasan langkah pengerjaan Tugas 8 serta konsep Navigation, Layouts, dan Forms di Flutter. Saya meminta penjelasan step by step beserta alasannya, bukan hanya kode jadi. Setiap langkah saya ketik sendiri, uji di Chrome, lalu baru lanjut ke langkah berikutnya. Bagian yang dibantu AI adalah rancangan field dan validasi formulir Edukasi (input kosong/spasi, panjang maksimal, rentang IPK, urutan tanggal), cara memakai showDatePicker(), penambahan kartu dan opsi drawer, serta draf awal jawaban reflektif yang kemudian saya baca ulang dan sesuaikan dengan pemahaman saya. Saya sendiri yang memilih bagian Edukasi beserta ikon dan warnanya.
- AI tidak bisa menjalankan flutter analyze atau run program untuk cek hasil, jadi hasilnya saya cek sendiri di Chrome (termasuk ukuran layar iPhone SE) dan dengan flutter analyze. Saat testing saya menemukan dan memperbaiki beberapa masalah: typo huruf "x" di showSnackBar yang membuat gagal compile, halaman utama overflow 294 px setelah menambah kartu keempat (diperbaiki dengan SingleChildScrollView), dan error "Cannot read properties of undefined (reading 'map')" setelah menambah variabel baru, yang ternyata karena hot reload tidak menginisialisasi ulang field State sehingga perlu hot restart (R).