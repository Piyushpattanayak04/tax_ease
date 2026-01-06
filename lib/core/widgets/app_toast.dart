import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

/// Custom toast/alert system that appears ABOVE the bottom navigation bar
/// with a neutral dark background, color-coded left accent bar, and Inter font.
class AppToast {
  static OverlayEntry? _currentToast;

  /// Shows a toast message with customizable type and auto-dismiss
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Remove existing toast if any
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        onDismiss: () {
          overlayEntry.remove();
          if (_currentToast == overlayEntry) {
            _currentToast = null;
          }
        },
      ),
    );

    overlay.insert(overlayEntry);
    _currentToast = overlayEntry;

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (_currentToast == overlayEntry) {
        overlayEntry.remove();
        _currentToast = null;
      }
    });
  }

  /// Convenience method for success toast
  static void success(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.success);
  }

  /// Convenience method for error toast
  static void error(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.error);
  }

  /// Convenience method for info toast
  static void info(BuildContext context, String message) {
    show(context: context, message: message, type: ToastType.info);
  }
}

/// Toast type determines the color-coded left accent bar
enum ToastType {
  info,    // Teal
  success, // Green
  error,   // Red
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getAccentColor() {
    switch (widget.type) {
      case ToastType.info:
        return AppColors.brandTeal;
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.errorLight;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.info:
        return Icons.info_outline;
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    final icon = _getIcon();

    return Positioned(
      left: 16,
      right: 16,
      // Position ABOVE the bottom nav bar (~100px from bottom)
      bottom: 108,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              // Neutral dark background
              color: const Color(0xFF2C2F3A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Color-coded left accent bar
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Icon
                Icon(
                  icon,
                  color: accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                // Message text
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
