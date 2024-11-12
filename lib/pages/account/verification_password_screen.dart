import 'package:flutter/material.dart';
import 'package:transitease_app/pages/account/change_password_screen.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/components/my_button.dart';
import 'package:transitease_app/components/verification_code_box.dart';

class VerificationPasswordScreen extends StatefulWidget {
  final String otp;

  const VerificationPasswordScreen({super.key, required this.otp});

  @override
  State<VerificationPasswordScreen> createState() =>
      _VerificationPasswordScreenState();
}

class _VerificationPasswordScreenState
    extends State<VerificationPasswordScreen> {
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();

  List<TextEditingController> otpControllers = [];

  @override
  void initState() {
    super.initState();
    otpControllers = [
      otpController1,
      otpController2,
      otpController3,
      otpController4
    ];
  }

  void verifyOtp() {
    String enteredOtp = otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text;

    if (enteredOtp == widget.otp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP, please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Verification",
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the Verification Code sent to your email",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VerificationCodeBox(controller: otpController1),
                      VerificationCodeBox(controller: otpController2),
                      VerificationCodeBox(controller: otpController3),
                      VerificationCodeBox(controller: otpController4),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Check your email for the OTP.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      textAlign: TextAlign.start,
                      "Didn't receive the code? Send Again",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color.fromARGB(255, 59, 106, 70),
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  MyButton(
                    onTap: verifyOtp,
                    label: "Verify",
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
