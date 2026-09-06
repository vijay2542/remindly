import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/core/localization/app_language.dart';
import 'package:remindly/core/localization/app_localizations.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('English localizations return correct strings', () {
      const l10n = AppLocalizations(AppLanguage.english);
      expect(l10n.get('appName'), equals('Remindly'));
      expect(l10n.get('memoriesTab'), equals('Memories'));
      expect(l10n.get('developerCredit'), equals('Developed by Vijay Sankar S'));
    });

    test('Tamil localizations return correct strings', () {
      const l10n = AppLocalizations(AppLanguage.tamil);
      expect(l10n.get('memoriesTab'), equals('நினைவுகள்'));
      expect(l10n.get('developerCredit'), contains('விஜய் சங்கர் எஸ்'));
    });

    test('Kannada localizations return correct strings', () {
      const l10n = AppLocalizations(AppLanguage.kannada);
      expect(l10n.get('memoriesTab'), equals('ನೆನಪುಗಳು'));
      expect(l10n.get('developerCredit'), contains('ವಿಜಯ್ ಶಂಕರ್ ಎಸ್'));
    });

    test('Tulu localizations return correct strings', () {
      const l10n = AppLocalizations(AppLanguage.tulu);
      expect(l10n.get('memoriesTab'), equals('ನೆನಪುಲು'));
      expect(l10n.get('developerCredit'), contains('ವಿಜಯ್ ಶಂಕರ್ ಎಸ್'));
    });

    test('Fallback to English when key missing in locale', () {
      const l10n = AppLocalizations(AppLanguage.tulu);
      expect(l10n.get('non_existent_key'), equals('non_existent_key'));
    });
  });
}
