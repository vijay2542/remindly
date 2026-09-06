class DatabaseException implements Exception {
  final String message;
  final dynamic cause;

  const DatabaseException(this.message, [this.cause]);

  @override
  String toString() => 'DatabaseException: $message';
}

class SearchException implements Exception {
  final String message;

  const SearchException(this.message);

  @override
  String toString() => 'SearchException: $message';
}

class VoiceException implements Exception {
  final String message;

  const VoiceException(this.message);

  @override
  String toString() => 'VoiceException: $message';
}

class ReminderException implements Exception {
  final String message;

  const ReminderException(this.message);

  @override
  String toString() => 'ReminderException: $message';
}
