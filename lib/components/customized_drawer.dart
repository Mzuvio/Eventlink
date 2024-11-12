import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:transitease_app/services/auth/auth_gate.dart';
import 'package:transitease_app/services/auth/auto_services.dart';
import 'package:transitease_app/screens/home_screen.dart';
import 'package:transitease_app/screens/events_screen.dart';
import 'package:transitease_app/screens/profile_screen.dart';
import 'package:transitease_app/components/customized_avatar.dart';
import 'package:transitease_app/utils/colors.dart';

class CustomizedDrawer extends StatelessWidget {
  CustomizedDrawer({super.key});

  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> fetchUserData() async {
    return await _authService.getUserData();
  }

  void _signOut() {
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authService = AuthService();
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: Color(0xFFF2F2F2),
      ),
      child: Drawer(
        backgroundColor: const Color(0xFFF2F2F2),
        child: ListView(
          children: [
            // Header section with user info
            FutureBuilder<Map<String, dynamic>?>(
              // Fetching user data
              future: fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const ListTile(
                    title: Text("User not found"),
                    subtitle: Text("Please log in"),
                  );
                }

                final userData = snapshot.data!;
                final userName = userData['fullName'] ?? "User";
                final userEmail = userData['email'] ?? "user@example.com";

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomizedAvatar(
                            fullname: userName,
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: GoogleFonts.lato(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Text(
                                    userEmail,
                                    style: GoogleFonts.lato(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          color: white,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Edit profile",
                                          style: GoogleFonts.lato(
                                            color: white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // Custom Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                thickness: 1,
                color: Color(0xFFced4da),
              ),
            ),
            // Drawer menu items
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              leading: const Icon(
                Icons.home_sharp,
                color: darkGrey,
                size: 20,
              ),
              title: Text(
                "Home",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventsScreen()),
                );
              },
              leading: const Icon(
                Icons.event,
                color: darkGrey,
                size: 20,
              ),
              title: Text(
                "Events",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16),
              ),
            ),

            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.invert_colors_on,
                color: darkGrey,
                size: 20,
              ),
              title: Text(
                "Theme",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                thickness: 1,
                color: Color(0xFFced4da),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: backgroundColor,
                      title: Text(
                        'Terms and Conditions',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Text(
                          '(:',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.lato(color: errorColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(
                Icons.article,
                color: darkGrey,
                size: 20,
              ),
              title: Text(
                "Terms and Conditions",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: backgroundColor,
                      title: Text(
                        'Confirm account deletion?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      content: Text(
                        'Are you sure you want to delete your account?',
                        style: GoogleFonts.lato(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel',
                              style: GoogleFonts.lato(color: primaryColor)),
                        ),
                        TextButton(
                          onPressed: () async {
                            await authService.deleteCurrentUser(userProvider);
                            Navigator.push(
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
              },
              leading: const Icon(
                Icons.delete,
                color: darkGrey,
                size: 20,
              ),
              title: Text(
                "Delete Account",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
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
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel',
                              style: GoogleFonts.lato(color: primaryColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            _signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthGate(),
                              ),
                            );
                          },
                          child: Text('Confirm',
                              style: GoogleFonts.lato(color: errorColor)),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(
                Icons.logout,
                color: darkGrey,
                size: 20,
              ),
              title: Text(
                "Sign Out",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
