import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<void> scheduleReminder(Reminder reminder);
  Future<void> cancelReminder(String memoryId);
}
