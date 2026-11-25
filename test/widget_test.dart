import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Tombol menampilkan SnackBar yang sesuai', (tester) async {
    // MockClient agar test tidak melakukan request jaringan sungguhan.
    final apiClient = ApiClient(
      client: MockClient((request) async => http.Response('[]', 200)),
    );
    await tester.pumpWidget(MyApp(apiClient: apiClient));

    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    // Kartu Logout ada di baris kedua grid, di luar layar tes 800x600,
    // jadi gulir dulu sampai terlihat sebelum diketuk.
    await tester.ensureVisible(find.text('Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pump();
    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
  });
}
