
import '../core/utils/app_logger.dart';
import '../models/tag_group.dart';
import 'supabase_managers/content_manager.dart';

/// Service for managing and caching tag group data.
/// 
/// This singleton service fetches all tag groups once at app startup
/// and provides easy access to tag group data throughout the app.
/// Equivalent to caching strategy used in iOS app.
class TagGroupService {
  static TagGroupService? _instance;
  static TagGroupService get shared => _instance ??= TagGroupService._();
  
  TagGroupService._();

  List<TagGroup>? _cachedTagGroups;
  bool _isLoading = false;

  /// Get all cached tag groups.
  /// 
  /// Returns null if tag groups haven't been loaded yet.
  /// Call [loadTagGroups] first to ensure data is available.
  List<TagGroup>? get allTagGroups => _cachedTagGroups;

  /// Check if tag groups have been loaded and cached.
  bool get isLoaded => _cachedTagGroups != null;

  /// Load all tag groups from the database and cache them.
  /// 
  /// This should be called once at app startup.
  /// Subsequent calls will return cached data unless [forceReload] is true.
  /// 
  /// Returns the list of tag groups or throws an exception if loading fails.
  Future<List<TagGroup>> loadTagGroups({bool forceReload = false}) async {
    // Return cached data if available and not forcing reload
    if (_cachedTagGroups != null && !forceReload) {
      return _cachedTagGroups!;
    }

    // Prevent multiple simultaneous loads
    if (_isLoading) {
      // Wait for existing load to complete
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedTagGroups ?? [];
    }

    _isLoading = true;

    try {
      final contentManager = ContentManager.shared;
      final tagGroups = await contentManager.fetchAllTagGroups();
      
      _cachedTagGroups = tagGroups;
      
      // Debug: Log all cached TagGroup codes
      AppLogger.debug('Cached TagGroup codes: ${tagGroups.map((tg) => tg.code).toList()}', context: 'TagGroupService');
      
      return tagGroups;
    } finally {
      _isLoading = false;
    }
  }

  /// Get a specific tag group by its code.
  /// 
  /// Returns null if the tag group is not found or if tag groups haven't been loaded.
  TagGroup? getTagGroupByCode(String code) {
    if (_cachedTagGroups == null) return null;
    
    try {
      return _cachedTagGroups!.firstWhere(
        (tagGroup) => tagGroup.code == code,
      );
    } catch (_) {
      // Not found
      return null;
    }
  }

  /// Get tag groups for specific codes.
  /// 
  /// Returns a list of tag groups matching the provided codes.
  /// Missing tag groups are excluded from the result.
  List<TagGroup> getTagGroupsByCodes(List<String> codes) {
    if (_cachedTagGroups == null) return [];
    
    return codes
        .map((code) => getTagGroupByCode(code))
        .where((tagGroup) => tagGroup != null)
        .cast<TagGroup>()
        .toList();
  }

  /// Initialize TagGroup cache after authentication.
  /// 
  /// This method loads all tag groups in the background after successful authentication.
  /// It does not block if it fails and is safe to call multiple times.
  Future<void> initializeAfterAuth() async {
    try {
      AppLogger.info('Initializing TagGroups cache after authentication', context: 'TagGroupService');
      final tagGroups = await loadTagGroups();
      AppLogger.success('TagGroups cache initialized with ${tagGroups.length} groups', context: 'TagGroupService');
    } catch (error) {
      AppLogger.warning('Failed to initialize TagGroups cache: $error', context: 'TagGroupService');
      // Don't throw - this is a background optimization
    }
  }

  /// Clear the cached tag groups.
  /// 
  /// Useful for testing or when you want to force a fresh load.
  void clearCache() {
    _cachedTagGroups = null;
  }
}