import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astromini/main.dart';
import 'package:astromini/services/storage_service.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);
    await tester.pumpWidget(AstroMiniApp(storageService: storage));
    expect(find.text('astromini'), findsOneWidget);
    expect(find.text('Zodiac Signs'), findsOneWidget);
  });
}
