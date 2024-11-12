import 'package:flutter/material.dart';
import 'package:transitease_app/utils/colors.dart';

class OutlinedTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final bool isPassword;
  final bool isEmail;
  final bool isFullname;
  final bool isPhone;

  const OutlinedTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
    required this.isPassword,
    required this.isEmail,
    required this.isFullname,
    required this.isPhone,
  });

  @override
  State<OutlinedTextfield> createState() => _OutlinedTextfieldState();
}

class _OutlinedTextfieldState extends State<OutlinedTextfield> {
  bool _isPasswordVisible = false;

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: mediumGrey,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obsecureText && !_isPasswordVisible,
        cursorColor: mediumGrey,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          fillColor: white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: mediumGrey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: darkGrey),
          ),
          suffixIcon:
              widget.obsecureText ? _buildPasswordVisibilityToggle() : null,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
