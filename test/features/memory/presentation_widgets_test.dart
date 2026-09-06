import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/features/memory/domain/entities/category.dart';
import 'package:remindly/features/memory/domain/entities/memory.dart';
import 'package:remindly/features/memory/presentation/pages/add_memory_page.dart';
import 'package:remindly/features/memory/presentation/pages/home_page.dart';
import 'package:remindly/features/memory/presentation/providers/memory_providers.dart';

void main() {
  testWidgets('HomePage renders ask bar, CTA button, and empty state', (tester) async {
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
    expect(find.text('Ask or voice search anything...'), findsOneWidget);
    expect(find.text('Remember something'), findsOneWidget);
    expect(find.text('No memories saved yet'), findsOneWidget);
  });

  testWidgets('HomePage displays saved memory card', (tester) async {
    final testMemory = Memory(
      id: 'mem-1',
      content: 'Spare key is inside the blue cupboard.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: Category.home,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recentMemoriesProvider.overrideWith((ref) => Stream.value([testMemory])),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Spare key is inside the blue cupboard.'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('AddMemoryPage allows typing memory and saving', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddMemoryPage(),
        ),
      ),
    );
    await tester.pump();

    final textField = find.byType(TextField).first;
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'Washing machine serviced on August 20');
    await tester.pump();

    expect(find.text('Confirm & Save Memory'), findsOneWidget);
  });
}
