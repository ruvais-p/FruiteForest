import 'package:flutter/material.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/analysis_page.dart';
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

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _navigate(context, page),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Smooth professional header
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menu",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _tile(
              context: context,
              icon: Icons.analytics_outlined,
              title: "Analysis",
              page: const AnalysisPage(),
            ),

            _tile(
              context: context,
              icon: Icons.store_outlined,
              title: "Store",
              page: const StorePage(),
            ),
          ],
        ),
      ),
    );
  }
}
