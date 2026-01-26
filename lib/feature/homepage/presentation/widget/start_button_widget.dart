
import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(const Size(100, 40)),

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),

        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.green.withValues(alpha: 0.4);
          }
          return AppColors.green;
        }),
      ),
      onPressed: onPressed,
      child: Text("Start", style: Theme.of(context).textTheme.displayMedium),
    );
  }
}
