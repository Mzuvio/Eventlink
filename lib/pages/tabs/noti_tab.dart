import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/notification_card.dart';
import 'package:transitease_app/providers/notifcation_provider.dart';
import 'package:transitease_app/utils/colors.dart';

class NotiTab extends StatefulWidget {
  const NotiTab({super.key});

  @override
  State<NotiTab> createState() => _NotiTabState();
}

class _NotiTabState extends State<NotiTab> {
  void _deleteNotification(BuildContext context, String notificationId) {
    Provider.of<NotificationProvider>(context, listen: false)
        .deleteNotification(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor,
      ),
      child: notifications.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                  child: NotificationCard(
                    deleteNotification: (context) => _deleteNotification(
                        context, notification.notificationId),
                    notification: notification,
                    onTap: () {},
                  ),
                );
              },
            )
          : Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'lib/assets/icons/mute.png',
                  fit: BoxFit.contain,
                  height: 100,
                ),
                const SizedBox(height: 25),
                Text(
                  'No events or updates right now. Check back later!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor,
                        fontSize: 13,
                      ),
                  textAlign: TextAlign.center, 
                ),
              ],
            ),
    );
  }
}
