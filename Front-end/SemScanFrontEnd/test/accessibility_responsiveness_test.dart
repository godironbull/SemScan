import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders without overflow on common sizes', (tester) async {
    Future<void> pumpWithSize(Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    await pumpWithSize(const Size(360, 640)); // phone portrait
    await pumpWithSize(const Size(640, 360)); // phone landscape
    await pumpWithSize(const Size(1024, 768)); // tablet
  });

  testWidgets('Accessibility: screen has readable texts', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
  });
}
