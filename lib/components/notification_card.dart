import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/models/notification_model.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationCard extends StatelessWidget {
  final void Function(BuildContext context)? deleteNotification;
  final void Function()? onTap;
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.deleteNotification,
    required this.notification,
    required this.onTap,
  });
  

  @override
  Widget build(BuildContext context) {
    Color leftBorderColor =
        notification.isRead ? Colors.green.shade600 : Colors.yellow;

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => deleteNotification?.call(context),
            icon: Icons.delete,
            backgroundColor: const Color(0XFFe5383b).withOpacity(.8),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
            border: Border(
              left: BorderSide(
                color: leftBorderColor,
                width: 5,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification',
                style: GoogleFonts.lato(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                notification.message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: darkGrey,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Time',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('h:mm a').format(notification.dateTime),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
