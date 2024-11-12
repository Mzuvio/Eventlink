import 'package:flutter/material.dart';
import 'package:transitease_app/utils/colors.dart';

class TermsAndConditionsCheckbox extends StatefulWidget {
  final void Function(bool? value)? onChanged;
  const TermsAndConditionsCheckbox({super.key, this.onChanged});

  @override
  State<TermsAndConditionsCheckbox> createState() =>
      _TermsAndConditionsCheckboxState();
}

class _TermsAndConditionsCheckboxState
    extends State<TermsAndConditionsCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: .7,
          child: Checkbox(
            activeColor: primaryColor,
            checkColor: Colors.white,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false; 
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value); 
              }
            },
          ),
        ),
        Text(
          "I agree to the Terms & Conditions",
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
