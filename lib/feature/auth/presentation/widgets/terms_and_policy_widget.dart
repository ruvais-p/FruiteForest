import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/auth/presentation/terms_and_policy/terms_and_policy_page.dart';

class TermsAndPolicyWidget extends StatefulWidget {
  const TermsAndPolicyWidget({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<TermsAndPolicyWidget> createState() => _TermsAndPolicyWidgetState();
}

class _TermsAndPolicyWidgetState extends State<TermsAndPolicyWidget> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isAccepted = !isAccepted;
            });
            widget.onChanged(isAccepted);
          },
          child: Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: isAccepted
                  ? AppColors
                        .yellow // ✅ change color
                  : AppColors.backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black, width: 2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text("Accept our ", style: Theme.of(context).textTheme.labelMedium),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsAndPolicyPage()),
          ),
          child: Text(
            "Terms & Conditions",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.yellow,
              decoration: TextDecoration.underline,
              decorationThickness: 2,
              decorationColor: AppColors.yellow,
            ),
          ),
        ),
      ],
    );
  }
}
