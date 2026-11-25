import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Home page shows the app title and menu', (
    WidgetTester tester,
  ) async {
    // Perbesar ukuran layar test supaya halaman utama tidak overflow.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Build app dan jalankan satu frame.
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    // Pastikan judul dan menu utama tampil.
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
  });
}