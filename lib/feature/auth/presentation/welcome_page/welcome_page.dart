import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruiteforest/feature/auth/presentation/login/login_page.dart';
import 'package:fruiteforest/feature/auth/presentation/widgets/bottom_button_auth_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 200),
            child: SvgPicture.asset('assets/images/welcome_image.svg'),
          ),
          BottomButtonAuthWidget(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ),
            buttonText: 'NEXT',
          ),
        ],
      ),
    );
  }
}
