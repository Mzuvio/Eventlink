import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/services/auth/auth_gate.dart';
import 'package:transitease_app/services/auth/auto_services.dart';
import 'package:transitease_app/utils/colors.dart';

class MyDropdownMenu extends StatefulWidget {
  const MyDropdownMenu({super.key});

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  final AuthService _authService = AuthService();

  void _signOut() {
    _authService.signOut();
  }

  bool _notificationsEnabled = false;

  void toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: white,
      icon: const Icon(
        Icons.more_vert,
        size: 24,
        color: Colors.white,
      ),
      onSelected: (String value) {
        switch (value) {
          case 'Notifications':
            toggleNotifications();
            break;

          case 'Logout':
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: backgroundColor,
                  title: Text(
                    'Sign Out',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  content: Text(
                    'Are you sure you want to sign out?',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.lato(color: primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthGate(),
                          ),
                        );
                      },
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.lato(color: errorColor),
                      ),
                    ),
                  ],
                );
              },
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'Notifications',
            child: Text(_notificationsEnabled
                ? 'Turn off Notifications'
                : 'Turn on Notifications'),
          ),
          const PopupMenuItem(
            value: 'Logout',
            child: Text('Logout'),
          ),
        ];
      },
    );
  }
}
