class NotificationModel {
  final String notificationId;
  final String message;
  final DateTime dateTime;
  bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.message,
    required this.dateTime,
    this.isRead = false,
  });
}
