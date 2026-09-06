import '../../../../core/services/notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final NotificationService notificationService;

  ReminderRepositoryImpl({required this.notificationService});

  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    final notificationId = reminder.memoryId.hashCode;
    await notificationService.scheduleNotification(
      id: notificationId,
      title: reminder.title,
      body: reminder.body,
      scheduledDate: reminder.scheduledDate,
      payload: reminder.memoryId,
    );
  }

  @override
  Future<void> cancelReminder(String memoryId) async {
    final notificationId = memoryId.hashCode;
    await notificationService.cancelNotification(notificationId);
  }
}
