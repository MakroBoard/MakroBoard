import 'dart:async';

class NotificationProvider {
  final StreamController<NotificationUpdate> _streamSnackBarNotificationController = StreamController<NotificationUpdate>.broadcast();
  Stream<NotificationUpdate> get snackBarNotifications => _streamSnackBarNotificationController.stream;

  void addSnackBarNotification(Notification notification) {
    _streamSnackBarNotificationController.add(NotificationUpdate(notification: notification, notificationUpdateType: NotificationUpdateType.add));
  }

  void hideSnackBarNotification(Notification notification) {
    _streamSnackBarNotificationController.add(NotificationUpdate(notification: notification, notificationUpdateType: NotificationUpdateType.remove));
  }
}

class NotificationUpdate {
  final Notification notification;
  final NotificationUpdateType notificationUpdateType;

  NotificationUpdate({required this.notification, required this.notificationUpdateType});
}

enum NotificationUpdateType { add, remove }
enum NotificationType { info, success, error }

class Notification {
  final String text;
  final NotificationType notificationType;
  final Duration? duration;

  Notification({
    required this.text,
    required this.notificationType,
    this.duration,
  });
}
