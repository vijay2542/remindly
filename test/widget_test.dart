import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/features/memory/presentation/pages/home_page.dart';
import 'package:remindly/features/memory/presentation/providers/memory_providers.dart';

void main() {
  testWidgets('App renders home page title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recentMemoriesProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Remindly'), findsOneWidget);
  });
}
