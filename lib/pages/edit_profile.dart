import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/outlined_textfield.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:transitease_app/utils/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      fullnameController.text = currentUser.fullName;
      emailController.text = currentUser.email;
      phoneController.text = currentUser.phone;
      locationController.text = currentUser.location ?? '';
    }
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await userProvider.updateUserDetails(
        fullName: fullnameController.text,
        email: emailController.text,
        phone: phoneController.text,
        location: locationController.text,
      );

      // If new passwords are provided, update the password
      if (newPasswordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        if (newPasswordController.text == confirmPasswordController.text) {
          await currentUser!.updatePassword(newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password updated successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New passwords do not match")),
          );
        }
      }

      Navigator.pop(context); // Close the progress dialog
      Navigator.pop(context); // Go back to the previous screen
    } catch (error) {
      Navigator.pop(context); // Close the progress dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          const SizedBox(height: 49),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xff28bca1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _saveChanges,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Edit Your \n Profile',
                    style: GoogleFonts.lato(
                      color: white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  'lib/assets/images/edit_profile_1.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: backgroundColor,
              padding: const EdgeInsets.only(top: 15, left: 25, right: 35),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    OutlinedTextfield(
                      controller: fullnameController,
                      hintText: 'Full Name',
                      obsecureText: false,
                      isPassword: false,
                      isEmail: false,
                      isFullname: true,
                      isPhone: false,
                    ),
                    const SizedBox(height: 15),
                    OutlinedTextfield(
                      controller: emailController,
                      hintText: 'Email',
                      obsecureText: false,
                      isPassword: false,
                      isEmail: true,
                      isFullname: false,
                      isPhone: false,
                    ),
                    const SizedBox(height: 15),
                    OutlinedTextfield(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      obsecureText: false,
                      isPassword: false,
                      isEmail: false,
                      isFullname: false,
                      isPhone: true,
                    ),
                    const SizedBox(height: 15),
                    OutlinedTextfield(
                      controller: locationController,
                      hintText: 'Location',
                      obsecureText: false,
                      isPassword: false,
                      isEmail: false,
                      isFullname: false,
                      isPhone: false,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Update Password',
                      style: GoogleFonts.lato(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedTextfield(
                      controller: newPasswordController,
                      hintText: 'New Password',
                      obsecureText: true,
                      isPassword: true,
                      isEmail: false,
                      isFullname: false,
                      isPhone: false,
                    ),
                    const SizedBox(height: 15),
                    OutlinedTextfield(
                      controller: confirmPasswordController,
                      hintText: 'Confirm New Password',
                      obsecureText: true,
                      isPassword: true,
                      isEmail: false,
                      isFullname: false,
                      isPhone: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
