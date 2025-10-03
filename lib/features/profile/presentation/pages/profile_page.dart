import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../shared/animations/smooth_animations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            SmoothAnimations.slideUp(
              child: _buildProfileHeader(),
            ),
            const SizedBox(height: 32),
            SmoothAnimations.slideUp(
              delay: const Duration(milliseconds: 200),
              child: _buildProfileOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              'JD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'john.doe@example.com',
            style: TextStyle(
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    final options = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit Profile',
        'subtitle': 'Update your personal information',
        'onTap': () {},
      },
      {
        'icon': Icons.security_outlined,
        'title': 'Security',
        'subtitle': 'Change password and security settings',
        'onTap': () {},
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'subtitle': 'Manage notification preferences',
        'onTap': () {},
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'subtitle': 'Get help and contact support',
        'onTap': () => context.go('/help-support'),
      },
      {
        'icon': Icons.logout,
        'title': 'Sign Out',
        'subtitle': 'Sign out of your account',
        'onTap': () async {
          await ThemeController.setLoggedIn(false);
          context.go('/welcome');
        },
        'isDestructive': true,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final option = options[index];
          final isDestructive = option['isDestructive'] as bool? ?? false;
          return ListTile(
            leading: Icon(
              option['icon'] as IconData,
              color: isDestructive ? AppColors.error : AppColors.grey600,
            ),
            title: Text(
              option['title'] as String,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppColors.error : null,
              ),
            ),
            subtitle: Text(option['subtitle'] as String),
            trailing: const Icon(Icons.chevron_right),
            onTap: option['onTap'] as VoidCallback,
          );
        },
      ),
    );
  }
}
