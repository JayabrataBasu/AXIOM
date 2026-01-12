// Basic widget test for Axiom.
//
// Tests will be expanded as the application grows.
// Stage 1: Minimal test to verify app launches.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:axiom/main.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AxiomApp(),
      ),
    );

    // Verify the app title is displayed.
    expect(find.text('Axiom - Debug Mode'), findsOneWidget);
  });
}
