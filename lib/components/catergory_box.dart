import 'package:flutter/material.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/models/category.dart';

class CatergoryBox extends StatelessWidget {
  final Category category;
  final void Function()? onTap;
  const CatergoryBox({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: lightGrey),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Center(
            child: Text(
              category.categoryName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 14, color: darkGrey),
            ),
          )),
    );
  }
}
