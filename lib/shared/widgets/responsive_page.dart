import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive.dart';

/// High-level page wrapper that applies SafeArea, breakpoint-aware padding,
/// and max-width constraints using [ResponsiveContainer].
///
/// Use this for most scrollable page bodies instead of duplicating
/// padding / width logic in every screen.
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final bool centerContent;
  final EdgeInsets? padding;

  const ResponsivePage({
    super.key,
    required this.child,
    this.centerContent = true,
    this.padding,
  });

  EdgeInsets _defaultPadding(BuildContext context) {
    final horizontal = Responsive.responsive<double>(
      context: context,
      mobile: AppDimensions.screenPadding,
      tablet: AppDimensions.screenPaddingLarge,
      desktop: AppDimensions.spacingXl,
    );

    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: AppDimensions.screenPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding ?? _defaultPadding(context);

    return SafeArea(
      child: ResponsiveContainer(
        centerContent: centerContent,
        padding: resolvedPadding,
        child: child,
      ),
    );
  }
}
