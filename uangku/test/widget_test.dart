// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:uangku/main.dart';

void main() {
  testWidgets('Alur splash dan onboarding membuka Beranda', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UangKuApp());

    expect(find.text('UangKu'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Kenali kondisi uangmu'), findsOneWidget);

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();

    expect(find.text('Catat pengeluaran pertamamu'), findsOneWidget);
    expect(find.text('Catat Pengeluaran'), findsOneWidget);
  });
}
