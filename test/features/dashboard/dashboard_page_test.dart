import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('DashboardPage renders Remindly and Diary module tiles', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Personal Life Management'), findsOneWidget);
    expect(find.text('Remindly'), findsWidgets);
    expect(find.text('Remember anything. Find it when you need it.'), findsOneWidget);
    expect(find.text('Diary'), findsWidgets);
    expect(find.text('Your private space for everyday thoughts and memories.'), findsOneWidget);
    expect(find.text('Open'), findsNWidgets(2));
  });
}
