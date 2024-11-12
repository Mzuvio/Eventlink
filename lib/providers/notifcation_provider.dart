import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:uuid/uuid.dart';
import 'package:transitease_app/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      notificationId: '1',
      message: 'You have a new event scheduled for tomorrow at 10 AM.',
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    NotificationModel(
      notificationId: '2',
      message: 'A new event has been added in your area.',
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      notificationId: '3',
      message: 'Don’t forget to RSVP for the upcoming workshop.',
      dateTime: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      notificationId: '4',
      message: 'Your event has been approved.',
      dateTime: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    NotificationModel(
      notificationId: '5',
      message: 'New updates are available for your events.',
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      notificationId: '6',
      message: 'You have a new message from an attendee.',
      dateTime: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
    )
  ];

  UnmodifiableListView<NotificationModel> get notifications =>
      UnmodifiableListView(_notifications);

  void addNotification(String message) {
    const uuid = Uuid();
    _notifications.add(NotificationModel(
      notificationId: uuid.v4(),
      message: message,
      dateTime: DateTime.now(),
    ));
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final notification = _notifications.firstWhere(
      (notif) => notif.notificationId == notificationId,
      orElse: () => throw Exception('Notification not found'),
    );
    notification.isRead = true;
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications
        .removeWhere((notif) => notif.notificationId == notificationId);
    notifyListeners();
  }
}
