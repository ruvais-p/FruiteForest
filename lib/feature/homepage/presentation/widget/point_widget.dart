import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class PointWidget extends StatelessWidget {
  const PointWidget({super.key, required this.point});
  final int point;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(21.5),
        boxShadow: [
          // Main shadow (bottom-right)
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),

          // Very light top-left shadow (for depth)
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset('assets/images/point_icon.svg'),
          ),
          const SizedBox(width: 4),
          Text(
            "$point Points",
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
