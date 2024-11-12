import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/pages/edit_profile.dart';
import 'package:transitease_app/pages/tabs/events_tab.dart';
import 'package:transitease_app/pages/tabs/noti_tab.dart';
import 'package:transitease_app/pages/tabs/personal_tab.dart';
import 'package:transitease_app/services/auth/auto_services.dart';
import 'package:transitease_app/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserData();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    AuthService authService = AuthService();
    return await authService.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: primaryColor,
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Error loading user data"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("User not found"));
            }

            final userData = snapshot.data!;
            final fullName = userData['fullName'] ?? "User";
            final email = userData['email'] ?? "user@example.com";
            final phone = userData['phone'] ?? "N/A";

            return Column(
              children: [
                const SizedBox(height: 49),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.mode_edit_outline_outlined,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Profile picture and details
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFFd5f2e3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 29, 188, 159),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                fullName[0].toUpperCase(),
                                style: GoogleFonts.lato(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.email_rounded,
                                color: white,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                email,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone,
                                color: white,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                phone,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: backgroundColor,
                        child: TabBar(
                          indicatorColor: primaryColor,
                          indicatorWeight: 3.0,
                          labelColor: primaryColor,
                          unselectedLabelColor: darkGrey,
                          labelStyle: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(
                              icon: Icon(
                                Icons.person,
                                size: 20,
                              ),
                              text: 'Personal Details',
                            ),
                            Tab(
                              icon: Icon(
                                Icons.event,
                                size: 20,
                              ),
                              text: 'Events',
                            ),
                            Tab(
                              icon: Icon(
                                Icons.notifications,
                                size: 20,
                              ),
                              text: 'Notifications',
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [PersonalTab(), EventsTab(), NotiTab()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
