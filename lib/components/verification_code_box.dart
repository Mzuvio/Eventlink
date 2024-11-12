import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transitease_app/utils/colors.dart';

class VerificationCodeBox extends StatefulWidget {
  final TextEditingController controller; // Accept controller for each box

  const VerificationCodeBox({super.key, required this.controller});

  @override
  State<VerificationCodeBox> createState() => _VerificationCodeBoxState();
}

class _VerificationCodeBoxState extends State<VerificationCodeBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextFormField(
        controller: widget.controller, // Use the passed controller
        cursorColor: darkGrey,
        onChanged: (value) {
          if (value.length == 1) {
            // Move to next field when 1 digit is entered
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          hintText: "0",
          hintStyle: Theme.of(context).textTheme.titleLarge,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: mediumGrey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
