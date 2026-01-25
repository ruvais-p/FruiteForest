import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

Widget styledDropdown({
  required BuildContext context,
  required String hint,
  required String? value,
  required List<String> items,
  required ValueChanged<String> onChanged,
}) {
  String _cap(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  final width = MediaQuery.of(context).size.width - 50;
  const height = 60.0;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        top: -3,
        left: 3,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.black, width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              hint,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.gray),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.black,
            ),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.black),
            dropdownColor: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(_cap(e))))
                .toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ),
      ),
    ],
  );
}
