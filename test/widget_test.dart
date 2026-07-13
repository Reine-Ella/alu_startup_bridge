import 'package:flutter_test/flutter_test.dart';
import 'package:startup_bridge/app/app.dart';

void main() {
  testWidgets('StartupBridge app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const StartupBridgeApp());

    expect(find.text('StartupBridge'), findsWidgets);
  });
}