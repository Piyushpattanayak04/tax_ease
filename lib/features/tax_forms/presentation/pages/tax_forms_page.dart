import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/smooth_scroll_physics.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/animations/smooth_animations.dart';

class TaxFormsPage extends StatelessWidget {
  const TaxFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Forms'),
        automaticallyImplyLeading: false,
      ),
      body: ResponsiveContainer(
        centerContent: false,
        padding: EdgeInsets.all(Responsive.responsive(
          context: context,
          mobile: AppDimensions.screenPadding,
          tablet: AppDimensions.screenPaddingLarge,
          desktop: AppDimensions.spacingXl,
        )),
        child: SingleChildScrollView(
          physics: const SmoothBouncingScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmoothAnimations.slideUp(
              child: Text(
                'Choose your tax filing type',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SmoothAnimations.slideUp(
              delay: const Duration(milliseconds: 200),
              child: _buildFormOption(
                context,
                icon: Icons.person_outline,
                title: 'Personal Tax Filing (T1)',
                subtitle: 'File your individual tax return',
                onTap: () => context.go('/tax-forms/filled-forms'),
              ),
            ),
            const SizedBox(height: 16),
            SmoothAnimations.slideUp(
              delay: const Duration(milliseconds: 400),
              child: _buildFormOption(
                context,
                icon: Icons.business_outlined,
                title: 'Business Tax Filing',
                subtitle: 'File your business tax return',
                onTap: () => context.go('/tax-forms/business'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildFormOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
