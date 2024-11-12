import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transitease_app/services/auth/auth_gate.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/pages/splash/intro_page_1.dart';
import 'package:transitease_app/pages/splash/intro_page_2.dart';
import 'package:transitease_app/pages/splash/intro_page_3.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _HomeState();
}

class _HomeState extends State<OnboardScreen> {
  final _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (!isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthGate(),
        ),
      );
    }
  }

  Future<void> _setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              // onboard screen 1
              IntroPage1(),
              // onboard screen 2
              IntroPage2(),
              // onboard screen 3
              IntroPage3()
            ],
          ),

          // indicator dot's
          Container(
              alignment: const Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip
                  GestureDetector(
                    // the jump method is used by pageView - controller
                    onTap: () => {_controller.jumpToPage(2)},
                    child: Text(
                      'Skip',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 18),
                    ),
                  ),
                  // smooth page indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 14,
                        dotColor: Colors.grey,
                        activeDotColor: primaryColor),
                    onDotClicked: (index) => {
                      _controller.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn)
                    },
                  ),
                  // next
                  onLastPage
                      ? GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AuthGate();
                                },
                              ),
                            )
                          },
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 18),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn)
                          },
                          child: Text(
                            'Next',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 18),
                          ),
                        )
                ],
              ))
        ],
      ),
    );
  }
}
