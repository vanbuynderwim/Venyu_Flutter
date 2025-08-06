import 'package:flutter/material.dart';

import 'avatar_view.dart';

/// A utility class for showing avatars in fullscreen view.
/// 
/// This provides a consistent fullscreen avatar viewing experience
/// across the app with black background and tap-to-dismiss functionality.
class AvatarFullscreenViewer {
  AvatarFullscreenViewer._();

  /// Shows an avatar in fullscreen view with black background.
  /// 
  /// The avatar is centered and sized to fit the screen while maintaining
  /// aspect ratio. User can tap anywhere to dismiss.
  /// 
  /// [context] - The build context to show the viewer in
  /// [avatarId] - The avatar ID to display
  /// [showBorder] - Whether to show border around avatar (default: false)
  /// [preserveAspectRatio] - Whether to preserve original aspect ratio (default: true)
  static Future<void> show({
    required BuildContext context,
    required String? avatarId,
    bool showBorder = false,
    bool preserveAspectRatio = true,
  }) async {
    if (avatarId == null) return;

    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Allow transparent background
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black, // Fully black background
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Avatar size = screen width minus 16pt on each side (32pt total)
                  final availableWidth = constraints.maxWidth - 32.0;
                  final availableHeight = constraints.maxHeight - 80.0; // Space for close button
                  
                  // Use the smaller dimension to ensure perfect circle
                  final avatarSize = availableWidth < availableHeight ? availableWidth : availableHeight;
                  
                  return Stack(
                    children: [
                      // Tap to dismiss
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      // Centered avatar
                      Center(
                        child: AvatarView(
                          avatarId: avatarId,
                          size: avatarSize,
                          showBorder: showBorder,
                          preserveAspectRatio: preserveAspectRatio,
                        ),
                      ),
                      // Close button (top-right)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: SafeArea(
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}