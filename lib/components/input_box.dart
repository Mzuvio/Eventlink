import 'package:flutter/material.dart';
import 'package:transitease_app/utils/colors.dart';

class InputBox extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final bool isPassword;
  final bool isEmail;
  final bool isFullname;
  final bool isPhone;

  const InputBox({
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
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  // Password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      // Obscure text based on conditions
      obscureText: widget.obsecureText && !_isPasswordVisible,
      cursorColor: mediumGrey,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: mediumGrey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: darkGrey),
        ),
        prefixIcon: _getPrefixIcon(),
        suffixIcon:
            widget.obsecureText ? _buildPasswordVisibilityToggle() : null,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Icon? _getPrefixIcon() {
    if (widget.isPassword) {
      return const Icon(Icons.lock, size: 16, color: mediumGrey);
    } else if (widget.isEmail) {
      return const Icon(Icons.email, size: 16, color: mediumGrey);
    } else if (widget.isFullname) {
      return const Icon(Icons.person, size: 16, color: mediumGrey);
    } else if (widget.isPhone) {
      return const Icon(Icons.phone, size: 16, color: mediumGrey);
    }
    return null;
  }

  IconButton? _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        size: 20,
        color: darkGrey,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }
}
