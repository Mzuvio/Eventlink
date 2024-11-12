import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/services/auth/auto_services.dart';
import 'package:transitease_app/services/auth/signin_or_signup.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/components/input_box.dart';
import 'package:transitease_app/components/my_button.dart';
import 'package:transitease_app/components/terms_and_conditions_checkbox.dart';

class SignupScreen extends StatefulWidget {
  final void Function()? onTap;

  const SignupScreen({super.key, required this.onTap});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  String? fullnameError;
  String? emailError;
  String? passwordError;
  String? repeatPasswordError;

  bool isChecked = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullnameController.dispose();
    super.dispose();
  }

  bool _validateFullname(String fullname) {
    const fullnamePattern = r'^[a-zA-Z ]+$';
    return RegExp(fullnamePattern).hasMatch(fullname);
  }

  bool _validateEmail(String email) {
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  bool _passwordMatch(String password, String repeatPassword) {
    return _validatePassword(password) &&
        repeatPassword.isNotEmpty &&
        repeatPassword.length >= 6 &&
        repeatPassword == password;
  }

  void _handleSignUp() async {
    setState(() {
      emailError = null;
      passwordError = null;
      fullnameError = null;
      repeatPasswordError = null;
    });

    if (!_validateFullname(fullnameController.text)) {
      setState(() {
        fullnameError = 'Please enter a valid fullname';
      });
      return;
    }
    if (!_validateEmail(emailController.text.trim())) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
      return;
    }
    if (!_validatePassword(passwordController.text.trim())) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
      });
      return;
    }
    if (!_passwordMatch(
        passwordController.text, confirmPasswordController.text.trim())) {
      setState(() {
        repeatPasswordError = 'Passwords don\'t match';
      });
      return;
    }
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    AuthService authService = AuthService();
    User? user = await authService.registerUser(
      fullName: fullnameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SigninOrSignup(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed, please try again')),
      );
    }
  }

  void _onCheckboxChanged(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
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
                    "Create an Account",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontSize: 35),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Sign up now to track your local transport and never miss your ride!',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 40),

                  // Fullname input
                  InputBox(
                    controller: fullnameController,
                    hintText: "Fullname",
                    obsecureText: false,
                    isPassword: false,
                    isEmail: false,
                    isPhone: false,
                    isFullname: true,
                  ),
                  if (fullnameError != null)
                    Text(
                      fullnameError!,
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          color: errorColor,
                          fontWeight: FontWeight.normal),
                    ),
                  const SizedBox(height: 10),

                  // Email input
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
                  const SizedBox(height: 10),

                  // Password input
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
                  const SizedBox(height: 10),

                  // Confirm Password input
                  InputBox(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obsecureText: true,
                    isPassword: true,
                    isEmail: false,
                    isPhone: false,
                    isFullname: false,
                  ),
                  if (repeatPasswordError != null)
                    Text(
                      repeatPasswordError!,
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          color: errorColor,
                          fontWeight: FontWeight.normal),
                    ),
                  const SizedBox(height: 5),

                  // Terms and Conditions Checkbox
                  TermsAndConditionsCheckbox(onChanged: _onCheckboxChanged),
                  const SizedBox(height: 5),
                  const SizedBox(height: 10),

                  // Sign Up Button
                  MyButton(onTap: _handleSignUp, label: "Sign Up"),
                  const SizedBox(height: 25),

                  // Already have an account prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Sign in ",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
