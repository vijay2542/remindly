enum AppLanguage {
  english('en', 'en-IN', 'en-US', 'English', 'English'),
  hindi('hi', 'hi-IN', 'hi-IN', 'Hindi', 'हिंदी'),
  tamil('ta', 'ta-IN', 'ta-IN', 'Tamil', 'தமிழ்'),
  kannada('kn', 'kn-IN', 'kn-IN', 'Kannada', 'ಕನ್ನಡ'),
  tulu('tcy', 'kn-IN', 'kn-IN', 'Tulu', 'ತುಳು');

  final String code;
  final String sttLocaleId;
  final String ttsLanguage;
  final String englishName;
  final String nativeName;

  const AppLanguage(
    this.code,
    this.sttLocaleId,
    this.ttsLanguage,
    this.englishName,
    this.nativeName,
  );

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
