import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/notification_provider.dart' as noti;

class SnackBarNotification extends StatelessWidget {
  final Widget child;

  const SnackBarNotification({required this.child});

  @override
  Widget build(BuildContext context) {
    Modular.get<noti.NotificationProvider>().snackBarNotifications.listen((notification) {
      switch (notification.notificationUpdateType) {
        case noti.NotificationUpdateType.add:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(notification.notification.text),
            behavior: SnackBarBehavior.floating,
            duration: notification.notification.duration ?? Duration(days: 10),
            // if(notification.notification.duration == null)
            action: notification.notification.duration == null
                ? SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  )
                : null,
            elevation: 8,
            backgroundColor: _getBackGroundColor(context, notification.notification),
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ));
          break;
        case noti.NotificationUpdateType.remove:
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          break;
      }
    });

    return child;
  }

  Color? _getBackGroundColor(BuildContext context, noti.Notification notification) {
    switch (notification.notificationType) {
      case noti.NotificationType.info:
        return Theme.of(context).accentColor;
      case noti.NotificationType.success:
        return Colors.green.shade600;
      case noti.NotificationType.error:
        return Theme.of(context).errorColor;
    }

    return null;
  }
}
