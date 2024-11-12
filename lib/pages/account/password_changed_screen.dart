import 'package:flutter/material.dart';
import 'package:transitease_app/services/auth/signin_or_signup.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/components/my_button.dart';

class PasswordChangedScreen extends StatelessWidget {

  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Varification",
          style: TextStyle(
              color: jetBlack, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/images/5.png",
                  fit: BoxFit.cover,
                  height: 250,
                ),

                const SizedBox(
                  height: 25,
                ),
                // title
                Text(
                  "Password Updated",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Your password has been successfully changed.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 15,
                ),

                const SizedBox(
                  height: 15,
                ),
                MyButton(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SigninOrSignup(),
                          ),
                        ),
                    label: "Sign In")
              ],
              // illustration

              // title

              // message

              // my but
            ),
          ),
        ),
      ),
    );
  }
}
