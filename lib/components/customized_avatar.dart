// components/customized_avatar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/utils/colors.dart';

class CustomizedAvatar extends StatelessWidget {
  final double size;
  final String fullname;
  const CustomizedAvatar({super.key, this.size = 70, required this.fullname});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFd5f2e3),
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: 1),
      ),
      child: ClipOval(
        child: Center(
          child: Text(
            fullname[0].toUpperCase(),
            style: GoogleFonts.lato(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
