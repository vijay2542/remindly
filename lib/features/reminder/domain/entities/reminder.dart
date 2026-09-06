class Reminder {
  final String memoryId;
  final String title;
  final String body;
  final DateTime scheduledDate;

  const Reminder({
    required this.memoryId,
    required this.title,
    required this.body,
    required this.scheduledDate,
  });
}
