import 'package:flutter/material.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/components/my_button.dart';
import 'package:transitease_app/services/auth/auto_services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Forgot password",
          style: TextStyle(
            color: jetBlack,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Illustration
                  Image.asset(
                    'lib/assets/images/6.png',
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                  const SizedBox(height: 25),
                  // Instruction
                  Text(
                    'Enter your email to receive a password reset link.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  // Email TextField
                  TextField(
                    cursorColor: mediumGrey,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon:
                          const Icon(Icons.email, size: 16, color: mediumGrey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: mediumGrey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: darkGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Send button
                  MyButton(
                    onTap: () async {
                      String email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        await _authService.sendPasswordResetEmail(email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Password reset email sent to $email'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter your email')),
                        );
                      }
                    },
                    label: 'Send Reset Link',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
