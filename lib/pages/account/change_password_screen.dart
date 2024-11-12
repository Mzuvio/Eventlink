import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/pages/account/password_changed_screen.dart';
import 'package:transitease_app/components/input_box.dart';
import 'package:transitease_app/components/my_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to change the user's password
  Future<void> changePassword() async {
    // Get the current user
    User? user = _auth.currentUser;
    if (user == null) {
      // If the user is not logged in, show an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is currently logged in.')),
      );
      return;
    }

    // Get the new password and confirm password
    String newPassword = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Check if the passwords match
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Passwords do not match. Please try again.')),
      );
      return;
    }

    // Check if the password is strong enough (at least 6 characters in this case)
    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password should be at least 6 characters.')),
      );
      return;
    }

    try {
      // Update the password
      await user.updatePassword(newPassword);
      // Show confirmation and navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully.')),
      );
      // Navigate to Password Changed Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PasswordChangedScreen(),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during the password change process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error changing password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Reset Password",
          style: TextStyle(
              color: jetBlack, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration
                Image.asset(
                  "lib/assets/images/4.png",
                  fit: BoxFit.cover,
                  height: 250,
                ),

                const SizedBox(
                  height: 25,
                ),
                // Title
                Text(
                  "Create New Password",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                // Content
                const SizedBox(
                  height: 15,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Your new password must be different from the previous password.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 15,
                ),
                // Text field for new password
                InputBox(
                  controller: passwordController,
                  hintText: "Password",
                  obsecureText: true,
                  isPassword: true,
                  isEmail: false,
                  isFullname: false,
                  isPhone: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                // Text field for confirm password
                InputBox(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obsecureText: true,
                  isPassword: true,
                  isEmail: false,
                  isFullname: false,
                  isPhone: false,
                ),
                // MyButton for updating password
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                  onTap: changePassword, // Call changePassword when tapped
                  label: "Create",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
