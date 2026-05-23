import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_app/main.dart';

void main() {
  testWidgets('MFashion app launches', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MFashionApp());

    // Verify splash screen text
    expect(find.text('FASHION'), findsOneWidget);
    expect(find.text('STORE'), findsOneWidget);

    // Advance past the splash delay to clear pending timers
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
