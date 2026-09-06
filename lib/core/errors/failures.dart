abstract class Failure {
  final String message;
  final dynamic cause;

  const Failure(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.cause]);
}

class SearchFailure extends Failure {
  const SearchFailure(super.message, [super.cause]);
}

class VoiceFailure extends Failure {
  const VoiceFailure(super.message, [super.cause]);
}

class ReminderFailure extends Failure {
  const ReminderFailure(super.message, [super.cause]);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.cause]);
}
