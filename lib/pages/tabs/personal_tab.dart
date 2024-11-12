import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:transitease_app/services/auth/auth_gate.dart';
import 'package:transitease_app/services/auth/auto_services.dart';
import 'package:transitease_app/utils/colors.dart';

class PersonalTab extends StatelessWidget {
  const PersonalTab({super.key});

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 15),
        Text(
          text,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  void _signOut() {
    AuthService authService = AuthService();
    authService.signOut();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    AuthService authService = AuthService();
    return await authService.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authService = AuthService();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: const BoxDecoration(color: backgroundColor),
      child: FutureBuilder<Map<String, dynamic>?>(
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
            return const Center(
              child: Text("User not found"),
            );
          }

          final userData = snapshot.data!;
          final fullName = userData['fullName'] ?? "User";
          final email = userData['email'] ?? "user@example.com";
          final phone = userData['phone'] ?? "N/A";
          final location = userData['location'] ?? "N/A";

          return ListView(
            children: [
              _buildInfoRow(Icons.person_outline, fullName, primaryColor),
              const Divider(thickness: 1, color: Color(0xFFced4da)),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.email_outlined, email, primaryColor),
              const SizedBox(height: 10),
              const Divider(thickness: 1, color: Color(0xFFced4da)),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.phone_outlined, phone, primaryColor),
              const SizedBox(height: 10),
              const Divider(thickness: 1, color: Color(0xFFced4da)),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.location_on_outlined, location, primaryColor),
              const SizedBox(height: 10),
              const Divider(thickness: 1, color: Color(0xFFced4da)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: backgroundColor,
                        title: Text(
                          'Confirm account deletion?',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
                child: _buildActionRow(
                    Icons.delete_outline, 'Delete account', errorColor),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1, color: Color(0xFFced4da)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: backgroundColor,
                        title: Text(
                          'Sign Out',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.lato(color: primaryColor),
                            ),
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
                child: _buildActionRow(
                    Icons.logout_outlined, 'Sign Out', errorColor),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoRow(icon, text, color),
        const Icon(Icons.arrow_forward_ios_rounded, color: darkGrey, size: 18),
      ],
    );
  }
}
