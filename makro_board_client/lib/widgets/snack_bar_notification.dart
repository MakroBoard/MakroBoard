import 'dart:async';

import 'package:flutter/material.dart';
import 'package:makro_board_client/provider/notification_provider.dart' as noti;
import 'package:provider/provider.dart';

class SnackBarNotification extends StatefulWidget {
  final Widget child;

  const SnackBarNotification({Key? key, required this.child}) : super(key: key);

  @override
  SnackBarNotificationState createState() => SnackBarNotificationState();
}

class SnackBarNotificationState extends State<SnackBarNotification> {
  // ignore: cancel_subscriptions
  StreamSubscription? _snackBarNotifications;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _snackBarNotifications ??= Provider.of<noti.NotificationProvider>(context, listen: false).snackBarNotifications.listen((notification) {
      if (_context == null) {
        return;
      }
      switch (notification.notificationUpdateType) {
        case noti.NotificationUpdateType.add:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(notification.notification.text),
            behavior: SnackBarBehavior.floating,
            duration: notification.notification.duration ?? const Duration(days: 10),
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
            margin: const EdgeInsets.all(8),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ));
          break;
        case noti.NotificationUpdateType.remove:
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          break;
      }
    });
  }

  @override
  void dispose() {
    _snackBarNotifications!.cancel();
    super.dispose();
  }

  BuildContext? _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return widget.child;
  }

  Color? _getBackGroundColor(BuildContext context, noti.Notification notification) {
    switch (notification.notificationType) {
      case noti.NotificationType.info:
        return Theme.of(context).colorScheme.secondary;
      case noti.NotificationType.success:
        return Colors.green.shade600;
      case noti.NotificationType.error:
        return Theme.of(context).colorScheme.error;
    }
  }
}
