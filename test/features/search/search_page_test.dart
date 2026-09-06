import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/features/search/presentation/pages/search_page.dart';

void main() {
  testWidgets('SearchPage renders voice search button and About icon', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SearchPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Voice Command Search button in empty state
    expect(find.text('Voice Command Search'), findsOneWidget);

    // Verify Mic icon in text field suffix / action bar
    expect(find.byIcon(Icons.mic), findsNWidgets(2));

    // Verify Info / About software icon in AppBar
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });
}
