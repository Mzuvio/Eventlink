import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/notification_card.dart';
import 'package:transitease_app/components/small_avatar.dart';
import 'package:transitease_app/providers/notifcation_provider.dart';
import 'package:transitease_app/utils/colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void _deleteNotification(BuildContext context, String notificationId) {
    Provider.of<NotificationProvider>(context, listen: false)
        .deleteNotification(notificationId);
  }

  void openNotification() {
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xff28bca1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 20,
                                color: white,
                              ),
                            ),
                          ),
                          Text(
                            "Notifications",
                            style: GoogleFonts.sansita(
                              fontSize: 18,
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SmallAvatar()
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),

                Container(
                  height: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  decoration: const BoxDecoration(color: primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Find out what’s happening around you.',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: white,
                              ),
                        ),
                      ),
                      Image.asset(
                        'lib/assets/images/notify.png',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: Container(
                    width: double.infinity,
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
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, bottom: 10),
                                child: NotificationCard(
                                  deleteNotification: (context) =>
                                      _deleteNotification(
                                          context, notification.notificationId),
                                  notification: notification,
                                  onTap: () {
                                    return openNotification();
                                  },
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: textColor,
                                      fontSize: 13,
                                    ),
                                textAlign: TextAlign.center, // Center the text
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}
