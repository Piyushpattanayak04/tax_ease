import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/animations/smooth_animations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      icon: Icons.receipt_long_rounded,
      title: 'Easy Tax Filing',
      description:
          'Complete your personal and business tax filings with our intuitive step-by-step forms. Save drafts and continue later at your convenience.',
    ),
    OnboardingItem(
      icon: Icons.cloud_upload_rounded,
      title: 'Secure Document Upload',
      description:
          'Upload your PAN, Aadhar, income proofs, and other documents securely. All files are encrypted and stored safely.',
    ),
    OnboardingItem(
      icon: Icons.track_changes_rounded,
      title: 'Real-time Tracking',
      description:
          'Track your filing status in real-time. Get notified when your tax return is in review, filed, or completed.',
    ),
    OnboardingItem(
      icon: Icons.download_for_offline_rounded,
      title: 'Download Summaries',
      description:
          'Download comprehensive summaries of your tax filings. Access your documents anytime, anywhere.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: TextButton(
                  onPressed: () => _navigateToAuth(),
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page view content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(AppDimensions.screenPadding),
                    child: SmoothAnimations.fadeIn(
                      duration: const Duration(milliseconds: 600),
                      child: _buildOnboardingItem(_items[index]),
                    ),
                  );
                },
              ),
            ),

            // Bottom section with indicator and buttons
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _items.length,
                    effect: WormEffect(
                      dotColor: AppColors.grey300,
                      activeDotColor: AppColors.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Previous',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.grey600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      
                      if (_currentPage > 0) const SizedBox(width: 16),

                      Expanded(
                        flex: _currentPage == 0 ? 1 : 2,
                        child: ElevatedButton(
                          onPressed: _currentPage == _items.length - 1
                              ? _navigateToAuth
                              : () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _currentPage == _items.length - 1 ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingItem(OnboardingItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with background
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            item.icon,
            size: 60,
            color: AppColors.white,
          ),
        ),

        const SizedBox(height: 48),

        // Title
        Text(
          item.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.grey800,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Description
        Text(
          item.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.grey600,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _navigateToAuth() {
    context.go('/signup');
  }
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
