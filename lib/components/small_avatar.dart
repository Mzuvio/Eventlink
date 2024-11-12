import 'package:flutter/material.dart';
import 'package:transitease_app/screens/profile_screen.dart';

class SmallAvatar extends StatelessWidget {
  const SmallAvatar({super.key});

  void _visitProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _visitProfile(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFd5f2e3),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xff28bca1), width: 1),
        ),
        child: ClipOval(
          child: Image.asset(
            'lib/assets/images/profile.png',
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}
