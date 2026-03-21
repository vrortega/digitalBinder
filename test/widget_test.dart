import 'package:flutter_test/flutter_test.dart';
import 'package:digital_binder/main.dart';
import 'package:digital_binder/views/splash/splash_screen.dart';
import 'package:digital_binder/views/homepage/home_page.dart';

void main() {
  testWidgets('Splash shows then navigates to home', (WidgetTester tester) async {

    await tester.pumpWidget(const DigitalBinderApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

  });
}