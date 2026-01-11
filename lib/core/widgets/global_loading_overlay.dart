import 'dart:ui';

import 'package:flutter/material.dart';

/// Controller to manage a global loading overlay across the app.
class LoadingOverlayController {
  LoadingOverlayController._();

  /// Number of active API calls that have requested the overlay.
  static int _activeRequests = 0;

  /// Notifier that indicates whether the overlay should be visible.
  static final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Call this when starting a user-visible API call.
  static void show() {
    _activeRequests++;
    if (!isLoading.value) {
      isLoading.value = true;
    }
  }

  /// Call this when an API call completes (success or error).
  static void hide() {
    if (_activeRequests > 0) {
      _activeRequests--;
    }
    if (_activeRequests <= 0 && isLoading.value) {
      _activeRequests = 0;
      isLoading.value = false;
    }
  }
}

/// Widget that overlays a blurred loading indicator on top of the whole screen
/// whenever [LoadingOverlayController.isLoading] is true.
class GlobalLoadingOverlay extends StatelessWidget {
  final Widget? child;

  const GlobalLoadingOverlay({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: LoadingOverlayController.isLoading,
      builder: (context, loading, _) {
        return Stack(
          children: [
            if (child != null) child!,
            if (loading)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.15),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
