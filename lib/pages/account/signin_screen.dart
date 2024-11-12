import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:transitease_app/services/auth/auth_gate.dart';
import 'package:transitease_app/services/auth/auto_services.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/pages/account/forgot_password.dart';
import 'package:transitease_app/components/input_box.dart';
import 'package:transitease_app/components/my_button.dart';

class SigninScreen extends StatefulWidget {
  final void Function()? onTap;

  const SigninScreen({super.key, required this.onTap});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  final AuthService _authService = AuthService(); 
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  void _handleSignIn() async {
    setState(() {
      emailError = null;
      passwordError = null;
      isLoading = true; 
    });

    if (_validateEmail(emailController.text.trim()) &&
        _validatePassword(passwordController.text.trim())) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await _authService.loginUser(emailController.text.trim(),
          passwordController.text.trim(), userProvider 
          );
      setState(() {
        isLoading = false; 
      });

      if (userProvider.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthGate(),
          ),
        );
      } else {
        setState(() {
          emailError = 'Incorrect email or password';
        });
      }
    } else {
      setState(() {
        if (!_validateEmail(emailController.text.trim())) {
          emailError = 'Please enter a valid email address';
        }
        if (!_validatePassword(passwordController.text)) {
          passwordError = 'Password must be at least 6 characters';
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_open_rounded,
                      size: 72,
                      color: textColor,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 35),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Please sign in to your account to proceed.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 40),
                    InputBox(
                      controller: emailController,
                      hintText: 'Email',
                      obsecureText: false,
                      isPassword: false,
                      isEmail: true,
                      isPhone: false,
                      isFullname: false,
                    ),
                    if (emailError != null)
                      Text(
                        emailError!,
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: errorColor,
                            fontWeight: FontWeight.normal),
                      ),
                    const SizedBox(height: 15),
                    InputBox(
                      controller: passwordController,
                      hintText: 'Password',
                      obsecureText: true,
                      isPassword: true,
                      isEmail: false,
                      isPhone: false,
                      isFullname: false,
                    ),
                    if (passwordError != null)
                      Text(
                        passwordError!,
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: errorColor,
                            fontWeight: FontWeight.normal),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: isLoading ? null : _handleSignIn,
                      label: isLoading ? "Signing In..." : "Sign In",
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Sign up ",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
