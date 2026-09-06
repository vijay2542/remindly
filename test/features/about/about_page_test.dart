import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/features/about/presentation/pages/about_page.dart';

void main() {
  testWidgets('AboutPage displays app details and developer credit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AboutPage(),
      ),
    );
    await tester.pump();

    expect(find.text('About Software'), findsNWidgets(2));
    expect(find.text('Remindly'), findsOneWidget);
    expect(find.text('Vijay Sankar S'), findsOneWidget);
    expect(find.text('Developed By'), findsOneWidget);
  });

  testWidgets('showAppAboutDialog opens dialog with developer info', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showAppAboutDialog(context),
            child: const Text('Show About'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show About'));
    await tester.pumpAndSettle();

    expect(find.text('Remindly'), findsOneWidget);
    expect(find.text('Vijay Sankar S'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });
}
