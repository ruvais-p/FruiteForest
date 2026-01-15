
import 'package:flutter/material.dart';
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
          category.label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _format(seconds),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onGiveUp,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Give Up"),
        ),
      ],
    );
  }
}
