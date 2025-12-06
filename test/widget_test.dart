import 'package:crm/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify that the title is present
    expect(find.text('CorporateNexus'), findsOneWidget);
    expect(find.text('Kurumsal Yönetim Sistemi'), findsOneWidget);

    // Verify text fields
    expect(find.widgetWithText(TextFormField, 'E-posta'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Şifre'), findsOneWidget);

    // Verify buttons
    expect(find.widgetWithText(ElevatedButton, 'Giriş Yap'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Şifremi Unuttum'), findsOneWidget);
  });
}
