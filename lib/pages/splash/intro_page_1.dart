// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:transitease_app/components/onboard_content.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const OnboardContent(
        title: "Welcome to EventLink",
        image: "lib/assets/images/1.png",
        description:
            "Stay connected with your community. Find the latest events and updates at your fingertips.",
      ),
    );
  }
}
