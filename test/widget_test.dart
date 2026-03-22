import 'package:flutter_test/flutter_test.dart';
import 'package:astromini/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AstroMiniApp());
    expect(find.text('astromini'), findsOneWidget);
    expect(find.text('Zodiac Signs'), findsOneWidget);
  });
}
