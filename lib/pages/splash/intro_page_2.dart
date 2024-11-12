import 'package:flutter/material.dart';
import 'package:transitease_app/components/onboard_content.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const OnboardContent(
        title: "Stay Informed",
        image: "lib/assets/images/2.png",
        description:
            "Never miss an important announcement, event, or community update!",
      ),
    );
  }
}
