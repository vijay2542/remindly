import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/repositories/reminder_repository_impl.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/usecases/cancel_reminder.dart';
import '../../domain/usecases/schedule_reminder.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl();
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return ReminderRepositoryImpl(notificationService: notificationService);
});

final scheduleReminderUseCaseProvider = Provider<ScheduleReminderUseCase>((ref) {
  final repo = ref.watch(reminderRepositoryProvider);
  return ScheduleReminderUseCase(repo);
});

final cancelReminderUseCaseProvider = Provider<CancelReminderUseCase>((ref) {
  final repo = ref.watch(reminderRepositoryProvider);
  return CancelReminderUseCase(repo);
});
