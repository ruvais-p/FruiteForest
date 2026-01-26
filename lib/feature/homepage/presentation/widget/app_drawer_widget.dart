import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/analysis_page.dart';
import 'package:fruiteforest/feature/homepage/bloc/home_bloc.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/drawer_tile_widget.dart';
import 'package:fruiteforest/feature/store/presentation/store_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigate(BuildContext context, Widget page) async {
    Navigator.pop(context); // 1️⃣ close drawer first

    await Future.delayed(
      const Duration(milliseconds: 250),
    ); // 2️⃣ wait for smooth close

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, _) => page,
        transitionsBuilder: (_, animation, _, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 24),
          SizedBox(
            height: 125,
            width: 125,
            child: Image.asset('assets/images/profile_image.png'),
          ),

          const SizedBox(height: 8),
          Text(
            "Ruvais P",
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(color: AppColors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/point_icon.svg',
                height: 16,
                width: 16,
              ),
              const SizedBox(width: 4),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (p, c) => p.points != c.points,
                builder: (context, state) {
                  return Text(
                    "${state.points}",
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.copyWith(color: AppColors.gray),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          DrawerTile(
            onTap: () {
              _navigate(context, const AnalysisPage());
            },
            title: "Analysis",
            icon: 'assets/images/point_icon.svg',
          ),
          DrawerTile(
            onTap: () {
              _navigate(context, const StorePage());
            },
            title: "Store",
            icon: 'assets/images/point_icon.svg',
          ),
          DrawerTile(
            onTap: () {
              _navigate(context, const AnalysisPage());
            },
            title: "History",
            icon: 'assets/images/point_icon.svg',
          ),
          DrawerTile(
            onTap: () {
              _navigate(context, const AnalysisPage());
            },
            title: "Settings",
            icon: 'assets/images/point_icon.svg',
          ),
        ],
      ),
    );
  }
}
