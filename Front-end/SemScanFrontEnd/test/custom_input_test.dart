import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/components/custom_input.dart';

void main() {
  testWidgets('CustomInput toggles password visibility', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomInput(
            label: 'Senha',
            controller: TextEditingController(),
            obscureText: true,
            showPasswordToggle: true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
