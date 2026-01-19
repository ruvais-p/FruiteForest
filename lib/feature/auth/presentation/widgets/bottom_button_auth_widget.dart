import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class BottomButtonAuthWidget extends StatelessWidget {
  const BottomButtonAuthWidget({
    super.key,
    required this.onTap,
    required this.buttonText,
  });
  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 54, right: 54, bottom: 40),
        height: 64,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          buttonText,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.black),
        ),
      ),
    );
  }
}
