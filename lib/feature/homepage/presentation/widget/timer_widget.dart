import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';

class CountdownWidget extends StatelessWidget {
  final int seconds;
  final VoidCallback onGiveUp;
  final ActivityCategory category;

  const CountdownWidget({
    super.key,
    required this.seconds,
    required this.onGiveUp,
    required this.category,
  });

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _format(seconds),
          style: TextStyle(
            fontFamily: "Outfit",
            fontSize: 48,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onGiveUp,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text(
            "Give Up",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ],
    );
  }
}
