import 'package:flutter/material.dart';

class SimpleTimerWidget extends StatelessWidget {
  final int seconds;
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const SimpleTimerWidget({
    super.key,
    required this.seconds,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(seconds),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: onStart, child: const Text("Start")),
            const SizedBox(width: 10),

            ElevatedButton(
              onPressed: isRunning ? onPause : null,
              child: const Text("Pause"),
            ),
            const SizedBox(width: 10),

            ElevatedButton(
              onPressed: onStop,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Stop"),
            ),
          ],
        ),
      ],
    );
  }
}
