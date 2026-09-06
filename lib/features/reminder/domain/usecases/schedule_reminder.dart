import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class ScheduleReminderUseCase {
  final ReminderRepository repository;

  ScheduleReminderUseCase(this.repository);

  Future<void> call(Reminder reminder) async {
    await repository.scheduleReminder(reminder);
  }
}
