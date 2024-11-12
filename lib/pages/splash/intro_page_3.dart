import 'package:flutter/material.dart';
import 'package:transitease_app/components/onboard_content.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const OnboardContent(
        title: "Get Involved",
        image: "lib/assets/images/3.png",
        description:
            "Discover, attend, and contribute to events that matter to you.",
      ),
    );
  }
}
