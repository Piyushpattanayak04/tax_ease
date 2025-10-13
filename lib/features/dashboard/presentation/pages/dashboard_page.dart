import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/animations/smooth_animations.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../tax_forms/data/services/t1_form_storage_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin {
  // Add unique keys to prevent GlobalKey duplication during rebuilds
  static const _welcomeKey = ValueKey('dashboard_welcome');
  static const _quickStatsKey = ValueKey('dashboard_quick_stats');
  static const _quickActionsKey = ValueKey('dashboard_quick_actions');
  static const _recentActivityKey = ValueKey('dashboard_recent_activity');
  static const _taxDeadlinesKey = ValueKey('dashboard_tax_deadlines');

  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaxEase'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          // Theme toggle
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              // Toggle theme using the controller
              // If currently system, assume light based on platform brightness
              ThemeController.toggle();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                SmoothAnimations.slideUp(
                  key: _welcomeKey,
                  child: _buildWelcomeSection(),
                ),

                const SizedBox(height: 24),

                // Progress tracker (separate neutral card)
                SmoothAnimations.slideUp(
                  delay: const Duration(milliseconds: 150),
                  child: _buildProgressCard(),
                ),

                const SizedBox(height: 24),

                // Quick stats
                SmoothAnimations.slideUp(
                  key: _quickStatsKey,
                  delay: const Duration(milliseconds: 300),
                  child: _buildQuickStats(),
                ),

                const SizedBox(height: 24),

                // Quick actions
                SmoothAnimations.slideUp(
                  key: _quickActionsKey,
                  delay: const Duration(milliseconds: 400),
                  child: _buildQuickActions(),
                ),

                const SizedBox(height: 24),

                // Recent activity
                SmoothAnimations.slideUp(
                  key: _recentActivityKey,
                  delay: const Duration(milliseconds: 600),
                  child: _buildRecentActivity(),
                ),

                const SizedBox(height: 24),

                // Tax deadlines
                SmoothAnimations.slideUp(
                  key: _taxDeadlinesKey,
                  delay: const Duration(milliseconds: 800),
                  child: _buildTaxDeadlines(),
                ),
                
                // Extra bottom padding to account for bottom nav
                const SizedBox(height: 100),
              ],
            ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.accentLight.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative shapes using brand colors
          Positioned(
            top: -25,
            right: -25,
            child: _decorShape(
              size: 100,
              color: AppColors.accentLight.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            bottom: -20,
            left: -15,
            child: _decorShape(
              size: 80,
              color: AppColors.primaryLight.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: ThemeController.userName,
                      builder: (context, name, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(now),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name.isEmpty ? 'Welcome Back!' : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Let\'s make tax filing effortless',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.white.withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Elegant avatar with brand colors
                  ValueListenableBuilder<String>(
                    valueListenable: ThemeController.userName,
                    builder: (context, name, _) {
                      final initials = _userInitials(name);
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.white.withOpacity(0.25),
                              AppColors.white.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Premium stats row
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStat(
                      icon: Icons.trending_up_rounded,
                      label: 'Filings',
                      value: '\$500',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStat(
                      icon: Icons.event_available_rounded,
                      label: 'Due Date',
                      value: 'Apr 30',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStat(
                      icon: Icons.schedule_rounded,
                      label: 'Time Left',
                      value: '45 days',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.white.withOpacity(0.9),
          size: 18,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.75),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _decorShape({
    required double size,
    required Color color,
    required BoxShape shape,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.0)],
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }

  String _greeting(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _userInitials(String name) {
    final parts = name.trim().split(RegExp(r"\s+")).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }


  Widget _buildProgressCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getProgressStatus(),
      builder: (context, snapshot) {
        final progressData = snapshot.data ?? {
          'progress': 0.0,
          'progressText': 'Get Started',
          'isComplete': false,
        };
        
        final progress = progressData['progress'] as double;
        final progressText = progressData['progressText'] as String;
        final isComplete = progressData['isComplete'] as bool;
        
        return GestureDetector(
          onTap: () => context.go('/tax-forms/personal'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
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
                // Progress indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: progress == 0.0
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        )
                      : Stack(
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Theme.of(context).dividerColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isComplete ? AppColors.success : AppColors.primary,
                              ),
                              strokeWidth: 3,
                            ),
                            Center(
                              child: isComplete
                                  ? Icon(
                                      Icons.check,
                                      color: AppColors.success,
                                      size: 16,
                                    )
                                  : Text(
                                      '${(progress * 100).toInt()}%',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(width: 12),
                // Progress text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'T1 Tax Form Progress',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        progressText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isComplete ? AppColors.success : null,
                          fontWeight: isComplete ? FontWeight.w600 : null,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey500,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Future<Map<String, dynamic>> _getProgressStatus() async {
    try {
      return await T1FormStorageService.instance.getProgressStatus();
    } catch (e) {
      return {
        'progress': 0.0,
        'progressText': 'Get Started',
        'isComplete': false,
      };
    }
  }


  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.description_outlined,
                title: 'Forms Filed',
                value: '2',
                subtitle: 'This year',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.pending_outlined,
                title: 'In Progress',
                value: '1',
                subtitle: 'Draft saved',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        // Use Wrap in a LayoutBuilder to avoid GridView rounding overflow issues
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 16.0;
            final itemWidth = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildActionCard(
                    icon: Icons.person_outline,
                    title: 'Personal Tax',
                    subtitle: 'File T1 return',
                    onTap: () => context.go('/tax-forms/personal'),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildActionCard(
                    icon: Icons.business_outlined,
                    title: 'Business Tax',
                    subtitle: 'File business return',
                    onTap: () => context.go('/tax-forms/business'),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildActionCard(
                    icon: Icons.upload_file_outlined,
                    title: 'Upload Documents',
                    subtitle: 'Add tax documents',
                    onTap: () => context.go('/documents/upload'),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildActionCard(
                    icon: Icons.track_changes_outlined,
                    title: 'Track Status',
                    subtitle: 'Check filing status',
                    onTap: () => context.go('/filing-status'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'icon': Icons.check_circle_outline,
        'title': 'Personal Tax Return Filed',
        'subtitle': '2 days ago',
        'color': AppColors.success,
      },
      {
        'icon': Icons.upload_file_outlined,
        'title': 'Documents Uploaded',
        'subtitle': '1 week ago',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.drafts_outlined,
        'title': 'Draft Saved',
        'subtitle': '2 weeks ago',
        'color': AppColors.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: Icon(
                  activity['icon'] as IconData,
                  color: activity['color'] as Color,
                ),
                title: Text(
                  activity['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(activity['subtitle'] as String),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingSm,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTaxDeadlines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important Deadlines',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Filing Deadline',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'April 30, 2024 - 45 days remaining',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
