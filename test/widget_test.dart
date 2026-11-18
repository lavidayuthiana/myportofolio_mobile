import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Tombol menampilkan SnackBar yang sesuai', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    await tester.tap(find.text('Logout'));
    await tester.pump();
    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
  });
}