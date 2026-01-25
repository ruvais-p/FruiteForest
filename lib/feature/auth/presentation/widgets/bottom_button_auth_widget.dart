import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class BottomButtonAuthWidget extends StatelessWidget {
  const BottomButtonAuthWidget({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isLoading = false,
  });
  final VoidCallback onTap;
  final String buttonText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 54, right: 54, bottom: 40),
        height: 64,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.black,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                buttonText,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.black),
              ),
      ),
    );
  }
}
