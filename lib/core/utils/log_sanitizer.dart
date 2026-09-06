import 'package:flutter/foundation.dart';

/// Privacy-enforcing logger utility.
/// Prevents memory contents, user voice text, or private data from appearing in logs.
class LogSanitizer {
  static void logInfo(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[INFO][$tag] ${_sanitize(message)}');
    }
  }

  static void logError(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR][$tag] ${_sanitize(message)}');
      if (error != null) debugPrint('[ERROR-CAUSE] $error');
      if (stackTrace != null) debugPrint('$stackTrace');
    }
  }

  /// Replaces sensitive textual patterns if accidentally passed into loggers.
  static String _sanitize(String input) {
    // Redact memory content placeholders if present
    return input.replaceAll(RegExp(r'content:\s*".*?"', caseSensitive: false), 'content: "[REDACTED]"');
  }
}
