import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    Widget line() {
      return Container(
        width: 27,
        height: 3,
        decoration: BoxDecoration(
          color: AppColors.gray,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _scaffoldKey.currentState?.openDrawer(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          line(),
          const SizedBox(height: 4),
          line(),
          const SizedBox(height: 4),
          line(),
        ],
      ),
    );
  }
}
