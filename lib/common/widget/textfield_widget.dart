import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 50;
    const lineHeight = 60.0;
    final totalHeight = lineHeight * maxLines;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🔹 Shadow
        Positioned(
          top: -3,
          left: 3,
          child: Container(
            width: width,
            height: totalHeight,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        // 🔹 Front container
        Container(
          width: width,
          height: totalHeight, 
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.multiline,
            minLines: maxLines,
            maxLines: maxLines,
            textAlignVertical: TextAlignVertical.top,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.black),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.gray),
            ),
          ),
        ),
      ],
    );
  }
}
