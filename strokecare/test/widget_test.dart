import 'package:flutter_test/flutter_test.dart';
import 'package:strokecare/main.dart'; // Import your main app
import 'package:flutter/material.dart';
import 'package:strokecare/login.dart'; // Import the login page

void main() {
  testWidgets('MainPage UI elements test', (WidgetTester tester) async {
    // Build the app with the necessary routes and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: const MainPage(),
        routes: {
          '/login': (context) => const LoginPage(), // Define the route to LoginPage
        },
      ),
    );

    // Verify that 'Stroke care' text is found.
    expect(find.text('Stroke \ncare'), findsOneWidget);

    // Verify that the 'Get Started' button is present.
    expect(find.text('Get Started'), findsOneWidget);

    // Tap on the 'Get Started' button and trigger a navigation event.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify that it navigates to the LoginPage and finds the 'Login' text.
    expect(find.text('Login'), findsOneWidget); // Assuming "Login" is the title text on LoginPage
  });
}
