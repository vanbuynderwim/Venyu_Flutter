
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/enums/remote_image_path.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';

/// MediaManager - Handles media and storage operations
/// 
/// This manager is responsible for:
/// - Image upload and storage
/// - Avatar management
/// - File deletion from storage
/// - Remote image URL generation
/// 
/// Features:
/// - Profile avatar upload/delete operations
/// - Secure file storage management
/// - Image URL retrieval with fallbacks
/// - UUID-based file naming
class MediaManager extends BaseSupabaseManager {
  static MediaManager? _instance;
  
  /// The singleton instance of [MediaManager].
  static MediaManager get shared {
    _instance ??= MediaManager._internal();
    return _instance!;
  }
  
  /// Private constructor for singleton pattern.
  MediaManager._internal();

  /// Get remote image URL - exact equivalent of iOS implementation
  Future<String?> getRemoteImage({
    required RemoteImagePath remotePath,
    String? imageID,
    int? size,
  }) async {
    return executeAuthenticatedRequest(() async {
      if (imageID == null || imageID.isEmpty) {
        return null;
      }
      
      AppLogger.info('Getting remote image URL for: $imageID', context: 'MediaManager');
      
      try {
        // Match old implementation: uppercase ID with .jpg extension
        final fileName = '${imageID.toUpperCase()}.jpg';
        
        // Use transform options for sizing like the old implementation
        final transformOptions = size != null 
            ? TransformOptions(
                height: size * 3,
                width: size * 3,
                resize: ResizeMode.cover,
                quality: 100,
              )
            : null;
        
        final url = client.storage
            .from(remotePath.value)
            .getPublicUrl(fileName, transform: transformOptions);
        
        AppLogger.success('Remote image URL generated: $url', context: 'MediaManager');
        return url;
      } catch (error) {
        AppLogger.warning('Failed to get remote image URL: $error', context: 'MediaManager');
        return null;
      }
    });
  }

  /// Get icon URL from Supabase storage - equivalent to iOS getIcon(icon:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Constructs filename with .png extension
  /// 2. Gets public URL from icons storage bucket
  /// 3. Returns the URL or null if failed
  String? getIcon(String icon) {
    try {
      final fileName = '${icon}_regular.png';
      
      final url = client.storage
          .from(RemoteImagePath.icons.value)
          .getPublicUrl(fileName);
      
      AppLogger.success('Generated icon URL for $icon: $url', context: 'MediaManager');
      return url;
      
    } catch (error) {
      AppLogger.error('Failed to get icon URL for $icon: $error', context: 'MediaManager');
      return null;
    }
  }

  /// Upload image to storage
  Future<void> uploadImage({
    required String bucket,
    required String path,
    required Uint8List imageData,
    String? contentType,
  }) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.storage('Uploading image to: $bucket/$path', context: 'MediaManager');
      
      await client.storage.from(bucket).uploadBinary(
        path,
        imageData,
      );
      
      AppLogger.success('Image uploaded successfully', context: 'MediaManager');
    });
  }

  /// Upload user profile avatar
  Future<String> uploadUserProfileAvatar(Uint8List imageData) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.storage('Uploading user profile avatar', context: 'MediaManager');
      
      // Generate unique avatar ID
      final avatarId = _generateUUID();
      final fileName = '$avatarId.jpg';
      final bucket = RemoteImagePath.avatars.value;
      
      await client.storage.from(bucket).uploadBinary(
        fileName,
        imageData,
      );
      
      AppLogger.success('Profile avatar uploaded with ID: $avatarId', context: 'MediaManager');
      return avatarId;
    });
  }

  /// Delete user profile avatar
  Future<void> deleteUserProfileAvatar({
    required String? avatarID,
  }) async {
    return executeAuthenticatedRequest(() async {
      if (avatarID == null || avatarID.isEmpty) {
        AppLogger.warning('No avatar ID provided for deletion', context: 'MediaManager');
        return;
      }
      
      AppLogger.storage('Deleting user profile avatar: $avatarID', context: 'MediaManager');
      
      final fileName = '$avatarID.jpg';
      final bucket = RemoteImagePath.avatars.value;
      
      await client.storage.from(bucket).remove([fileName]);
      
      AppLogger.success('Profile avatar deleted successfully', context: 'MediaManager');
    });
  }

  /// Delete file from storage
  Future<void> deleteFileFromStorage({
    required String bucket,
    required String path,
  }) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.storage('Deleting file from storage: $bucket/$path', context: 'MediaManager');
      
      await client.storage.from(bucket).remove([path]);
      
      AppLogger.success('File deleted from storage successfully', context: 'MediaManager');
    });
  }

  /// Generates a UUID string for file IDs.
  /// 
  /// Helper method to generate unique identifiers for files.
  /// Equivalent to Swift's UUID().
  String _generateUUID() {
    const uuid = Uuid();
    return uuid.v4().toUpperCase();
  }
}