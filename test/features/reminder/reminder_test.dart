import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remindly/core/services/notification_service.dart';
import 'package:remindly/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:remindly/features/reminder/domain/entities/reminder.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockNotificationService mockNotificationService;
  late ReminderRepositoryImpl repository;

  setUp(() {
    mockNotificationService = MockNotificationService();
    repository = ReminderRepositoryImpl(notificationService: mockNotificationService);
  });

  group('Reminder Scheduling & Local Notification Tests', () {
    final reminder = Reminder(
      memoryId: 'mem-123',
      title: 'Renew car insurance',
      body: 'Car insurance due on November 15.',
      scheduledDate: DateTime(2026, 11, 15, 9, 0),
    );

    test('scheduleReminder delegates to NotificationService with memoryId payload', () async {
      when(() => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});

      await repository.scheduleReminder(reminder);

      verify(() => mockNotificationService.scheduleNotification(
            id: reminder.memoryId.hashCode,
            title: reminder.title,
            body: reminder.body,
            scheduledDate: reminder.scheduledDate,
            payload: 'mem-123',
          )).called(1);
    });

    test('cancelReminder delegates cancellation to NotificationService', () async {
      when(() => mockNotificationService.cancelNotification(any())).thenAnswer((_) async {});

      await repository.cancelReminder('mem-123');

      verify(() => mockNotificationService.cancelNotification('mem-123'.hashCode)).called(1);
    });
  });
}
