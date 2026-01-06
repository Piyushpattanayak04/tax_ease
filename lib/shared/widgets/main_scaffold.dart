import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentPath == '/home',
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        // Handle back button navigation
        if (currentPath == '/home') {
          // Exit app when on home page
          SystemNavigator.pop();
        } else {
          // Navigate to home for other bottom nav screens
          context.go('/home');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Main content that goes behind the floating nav
            child,
            // Floating bottom navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomNavigationBar(currentPath: currentPath),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  final String currentPath;
  const _BottomNavigationBar({required this.currentPath});

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    // Always read the router's current location so the highlight updates on navigation
    final String location = widget.currentPath;

    debugPrint('Current location: $location');

    return Container(
      height: 76,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.brandNavy,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                route: '/home',
                isActive: location == '/home',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.description_outlined,
                activeIcon: Icons.description,
                route: '/tax-forms/filled-forms',
                isActive: location.startsWith('/tax-forms'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.folder_outlined,
                activeIcon: Icons.folder,
                route: '/documents',
                isActive: location.startsWith('/documents'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                route: '/profile',
                isActive: location == '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String route,
    required bool isActive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color activeColor = AppColors.brandTeal;
    final Color inactiveColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          debugPrint('Tapping route: $route');
          context.go(route);
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.white.withValues(alpha: 0.08)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey('${route}_$isActive'),
                  color: isActive ? activeColor : inactiveColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isActive ? 14 : 0,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
