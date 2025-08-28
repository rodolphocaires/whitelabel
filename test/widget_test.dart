// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whitelabel/main.dart';

void main() {
  testWidgets('White label app loads successfully', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WhiteLabelApp());

    // Wait for splash screen and brand config to load
    await tester.pump();

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // Look for common UI elements that should be present
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
