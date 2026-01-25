import 'package:flutter/material.dart';

class TermsAndPolicyPage extends StatelessWidget {
  const TermsAndPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Policy"),
      ),
      body: const Center(
        child: Text("Terms and Policy Content Goes Here"),
      ),
    );
  }
}