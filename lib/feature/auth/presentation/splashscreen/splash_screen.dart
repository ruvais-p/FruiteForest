import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fruiteforest/feature/auth/presentation/createuser/create_user_page.dart';
import 'package:fruiteforest/feature/auth/presentation/login/login_page.dart';
import 'package:fruiteforest/feature/auth/repository/auth_repository.dart';
import 'package:fruiteforest/feature/homepage/presentation/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final String _text = "Fruit Forest";
  String _displayText = "";

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    int index = 0;

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (index < _text.length) {
        setState(() {
          _displayText += _text[index];
        });
        index++;
      } else {
        timer.cancel();
        _navigateNext();
      }
    });
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final repo = AuthRepository(Supabase.instance.client);
    final result = await repo.resolveUserFlow();

    if (!mounted) return;

    switch (result) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CreateProfilePage()),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text(
          _displayText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
