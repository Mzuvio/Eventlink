import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:transitease_app/pages/add_event.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/screens/events_screen.dart';
import 'package:transitease_app/pages/home_page.dart';
import 'package:transitease_app/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    const HomePage(),
    const EventsScreen(),
    const AddEvent(),
    const ProfileScreen()
  ];
  void _onChangeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, -1),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
            color: const Color(0xFFF5F5F5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GNav(
              backgroundColor: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(16),
              color: darkGrey,
              activeColor: primaryColor,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(
                color: primaryColor,
                width: 1,
              ),
              iconSize: 24,
              gap: 8,
              onTabChange: _onChangeScreen,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: 'Events',
                ),
                GButton(
                  icon: Icons.add_circle_outline_rounded,
                  text: 'Create Event',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
