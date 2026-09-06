import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_language.dart';
import 'app_localizations.dart';

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english);

  void setLanguage(AppLanguage language) {
    state = language;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

final localizationsProvider = Provider<AppLocalizations>((ref) {
  final language = ref.watch(languageProvider);
  return AppLocalizations(language);
});
