import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen logs in and pops', (WidgetTester tester) async {
    final userProvider = UserProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: userProvider,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              // Push LoginScreen so that Navigator.pop works
              Future.microtask(() => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ));
              return const Scaffold(body: Text('Home'));
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
    expect(userProvider.isLoggedIn, isFalse);

    final acessarButton = find.text('Acessar conta');
    expect(acessarButton, findsOneWidget);

    await tester.tap(acessarButton);
    await tester.pumpAndSettle();

    expect(userProvider.isLoggedIn, isTrue);
  });
}
