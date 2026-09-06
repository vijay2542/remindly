import '../repositories/reminder_repository.dart';

class CancelReminderUseCase {
  final ReminderRepository repository;

  CancelReminderUseCase(this.repository);

  Future<void> call(String memoryId) async {
    await repository.cancelReminder(memoryId);
  }
}
