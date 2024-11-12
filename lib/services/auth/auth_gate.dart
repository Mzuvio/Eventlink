import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transitease_app/screens/home_screen.dart';
import 'package:transitease_app/services/auth/signin_or_signup.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) { 
              return const HomeScreen();
            } else {
              return const SigninOrSignup();
            }
          },),
    );
  }
}
