import 'package:flutter/material.dart';
import 'package:transitease_app/pages/account/signin_screen.dart';
import 'package:transitease_app/pages/account/signup_screen.dart';

class SigninOrSignup extends StatefulWidget {
  const SigninOrSignup({super.key});

  @override
  State<SigninOrSignup> createState() => _SigninOrSignupState();
}

class _SigninOrSignupState extends State<SigninOrSignup> {
  // initiallly, show login screen
  bool showSignInScreen = true;

  // change to different screens
  void toggleScreen() {
    setState(() {
      // change the show screen to false
      showSignInScreen = !showSignInScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignInScreen
        ? SigninScreen(onTap: toggleScreen)
        : SignupScreen(onTap: toggleScreen);
  }
}
