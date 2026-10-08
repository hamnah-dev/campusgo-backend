import 'package:flutter_test/flutter_test.dart';

import 'package:campuseats_frontend/main.dart';

void main() {
  testWidgets('Campus Eats splash screen smoke test', (WidgetTester tester) async {
    // Build our Campus Eats app and trigger a frame.
    await tester.pumpWidget(const CampusEatsApp());

    // Verify that the app displays the splash screen title correctly.
    expect(find.text('Campus Eats'), findsOneWidget);
    expect(find.text('Good food. Right where you are.'), findsOneWidget);

    // Let the splash screen's delayed navigation finish so no timers stay pending.
    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();
  });
}