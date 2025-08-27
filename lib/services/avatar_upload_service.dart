import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/utils/app_logger.dart';
import '../core/utils/dialog_utils.dart';
import 'session_manager.dart';
import 'toast_service.dart';

/// Service for handling avatar upload operations
/// 
/// Provides reusable avatar upload functionality that can be used across
/// different screens (profile_header, edit_avatar_view, etc.)
class AvatarUploadService {
  AvatarUploadService._();
  
  /// Picks an image from the specified source and uploads it
  /// 
  /// Returns true if upload was successful, false if cancelled or failed
  /// Shows appropriate toast messages for success/failure
  static Future<bool> pickAndUploadAvatar({
    required BuildContext context,
    required ImageSource source,
    VoidCallback? onUploadStart,
    VoidCallback? onUploadComplete,
  }) async {
    try {
      // Notify upload start
      onUploadStart?.call();
      
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 100,
      );
      
      if (pickedFile == null) {
        // User cancelled - notify complete without error
        onUploadComplete?.call();
        return false;
      }
      
      final imageBytes = await pickedFile.readAsBytes();
      
      // Upload to server
      await SessionManager.shared.uploadUserProfileAvatar(imageBytes);
      
      // Show success message
      /*if (context.mounted) {
        ToastService.success(
          context: context,
          message: 'Profile photo updated successfully',
        );
      }*/
      
      // Notify upload complete
      onUploadComplete?.call();
      
      return true;
    } catch (error) {
      AppLogger.error('Avatar upload error: $error', context: 'AvatarUploadService');
      
      // Show error message
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to upload photo. Please try again.',
        );
      }
      
      // Notify upload complete (even on error)
      onUploadComplete?.call();
      
      return false;
    }
  }
  
  /// Picks image from camera and uploads it
  static Future<bool> pickFromCameraAndUpload({
    required BuildContext context,
    VoidCallback? onUploadStart,
    VoidCallback? onUploadComplete,
  }) async {
    return await pickAndUploadAvatar(
      context: context,
      source: ImageSource.camera,
      onUploadStart: onUploadStart,
      onUploadComplete: onUploadComplete,
    );
  }
  
  /// Picks image from gallery and uploads it
  static Future<bool> pickFromGalleryAndUpload({
    required BuildContext context,
    VoidCallback? onUploadStart,
    VoidCallback? onUploadComplete,
  }) async {
    return await pickAndUploadAvatar(
      context: context,
      source: ImageSource.gallery,
      onUploadStart: onUploadStart,
      onUploadComplete: onUploadComplete,
    );
  }
  
  /// Removes the current user's avatar after confirmation
  /// 
  /// Shows confirmation dialog and removes avatar if confirmed
  /// Returns true if avatar was removed, false if cancelled
  static Future<bool> removeAvatar({
    required BuildContext context,
    VoidCallback? onRemoveStart,
    VoidCallback? onRemoveComplete,
  }) async {
    try {
      // Show confirmation dialog
      final confirmed = await DialogUtils.showRemoveAvatarDialog(context);
      if (!confirmed) {
        return false;
      }
      
      // Notify removal start
      onRemoveStart?.call();
      
      // Remove avatar via SessionManager
      await SessionManager.shared.deleteProfileAvatar();
      
      // Show success message
      /*if (context.mounted) {
        ToastService.success(
          context: context,
          message: 'Profile photo removed successfully',
        );
      }*/
      
      // Notify removal complete
      onRemoveComplete?.call();
      
      return true;
    } catch (error) {
      AppLogger.error('Avatar removal error: $error', context: 'AvatarUploadService');
      
      // Show error message
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to remove photo. Please try again.',
        );
      }
      
      // Notify removal complete (even on error)
      onRemoveComplete?.call();
      
      return false;
    }
  }
}