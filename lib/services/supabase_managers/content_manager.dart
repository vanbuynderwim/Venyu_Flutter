
import '../../models/models.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';
import '../../mixins/disposable_manager_mixin.dart';

/// ContentManager - Handles content and prompt operations
/// 
/// This manager is responsible for:
/// - Card/prompt management (fetch, create, update)
/// - Tag group operations
/// - Pending review management (admin features)
/// - Prompt interactions and status updates
/// - Content approval workflows
/// 
/// Features:
/// - Personal and company tag group fetching
/// - Prompt CRUD operations
/// - Admin review and approval workflows
/// - Batch prompt status updates
/// - Interaction tracking
class ContentManager extends BaseSupabaseManager with DisposableManagerMixin {
  static ContentManager? _instance;
  
  /// The singleton instance of [ContentManager].
  static ContentManager get shared {
    _instance ??= ContentManager._internal();
    return _instance!;
  }
  
  /// Private constructor for singleton pattern.
  ContentManager._internal();

  /// Fetch tag groups by category type
  Future<List<TagGroup>> fetchTagGroups(CategoryType type) async {
    checkNotDisposed('ContentManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching tag groups for type: ${type.name}', context: 'ContentManager');
      
      final result = await client
          .rpc('get_taggroups', params: {'p_category_type': type.name})
          .select();
      
      final tagGroups = (result as List<dynamic>)
          .map((json) => TagGroup.fromJson(json))
          .toList();
      
      AppLogger.success('Fetched ${tagGroups.length} tag groups', context: 'ContentManager');
      return tagGroups;
    });
  }

  /// Fetch all tag groups
  Future<List<TagGroup>> fetchAllTagGroups() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching all tag groups', context: 'ContentManager');
      
      final result = await client
          .rpc('get_all_taggroups')
          .select();
      
      final tagGroups = (result as List<dynamic>)
          .map((json) => TagGroup.fromJson(json))
          .toList();
      
      AppLogger.success('Fetched ${tagGroups.length} total tag groups', context: 'ContentManager');
      return tagGroups;
    });
  }

  /// Fetch specific tag group with tags
  Future<TagGroup> fetchTagGroup(TagGroup tagGroup) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching tag group: ${tagGroup.title}', context: 'ContentManager');
      
      final result = await client
          .rpc('get_taggroup', params: {'p_code': tagGroup.code})
          .select()
          .single();
      
      final fetchedTagGroup = TagGroup.fromJson(result);
      AppLogger.success('Tag group fetched with ${fetchedTagGroup.tags?.length ?? 0} tags', context: 'ContentManager');
      
      return fetchedTagGroup;
    });
  }

  /// Update profile tags for a specific tag group
  Future<void> upsertProfileTags(String code, List<Tag> tags) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile tags for code: $code', context: 'ContentManager');
      
      final payload = {
        'code': code,
        'value_ids': tags.map((tag) => tag.id).toList(),
      };
      
      await client.rpc('upsert_profile_tags', params: {'payload': payload});
      
      AppLogger.success('Profile tags updated successfully', context: 'ContentManager');
    });
  }

  /// Update single profile tag
  Future<void> upsertProfileTag(String code, Tag tag) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating single profile tag for code: $code', context: 'ContentManager');
      
      final payload = {
        'code': code,
        'value_id': tag.id,
      };
      
      await client.rpc('upsert_profile_tag', params: {'payload': payload});
      
      AppLogger.success('Profile tag updated successfully', context: 'ContentManager');
    });
  }

  /// Fetch user's prompts with pagination
  Future<List<Prompt>> fetchProfilePrompts(PaginatedRequest paginatedRequest) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching user prompts with pagination: $paginatedRequest', context: 'ContentManager');

      // Call the get_profile_prompts RPC function with payload
      final result = await client
          .rpc('get_profile_prompts', params: {'payload': paginatedRequest.toJson()})
          .select();

      AppLogger.success('Profile prompts RPC call successful', context: 'ContentManager');
      AppLogger.debug('Prompt data received: ${result.length} prompts', context: 'ContentManager');

      // Convert response to list of Prompt objects
      final prompts = (result as List)
          .map((json) => Prompt.fromJson(json))
          .toList();

      AppLogger.success('Prompts parsed: ${prompts.length} prompts', context: 'ContentManager');
      return prompts;
    });
  }

  /// Fetch a single prompt by ID
  Future<Prompt?> fetchPrompt(String promptId) async {
    checkNotDisposed('ContentManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching prompt with ID: $promptId', context: 'ContentManager');

      // Call the get_prompt RPC function
      final result = await client
          .rpc('get_prompt', params: {'p_prompt_id': promptId})
          .select()
          .single();

      AppLogger.success('Prompt RPC call successful', context: 'ContentManager');
      AppLogger.debug('Prompt data received: $result', context: 'ContentManager');

      final prompt = Prompt.fromJson(result);
      AppLogger.success('Prompt parsed successfully', context: 'ContentManager');
      return prompt;
    });
  }

  /// Update the status of a prompt/card
  Future<void> updatePromptStatus({
    required String promptId,
    required PromptStatus status,
  }) async {
    AppLogger.info('Updating prompt $promptId status to: ${status.value}', context: 'ContentManager');
    
    return executeAuthenticatedRequest(() async {
      final payload = {
        'prompt_id': promptId,
        'status': status.value,
      };
      
      AppLogger.network('Calling update_prompt_status RPC with payload: $payload', context: 'ContentManager');
      
      // Pass the payload as a single JSONB parameter as expected by the PostgreSQL function
      await client.rpc('update_prompt_status', params: {'payload': payload});
      
      AppLogger.success('Prompt status updated successfully', context: 'ContentManager');
    });
  }

  /// Fetch prompts (alias for fetchCards for API compatibility)
  Future<List<Prompt>> fetchPrompts() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching prompts for user interaction', context: 'ContentManager');
      
      final List<dynamic> data = await client.rpc('get_prompts');
      final prompts = data.map((json) => Prompt.fromJson(json as Map<String, dynamic>)).toList();
      
      AppLogger.success('Fetched ${prompts.length} prompts', context: 'ContentManager');
      return prompts;
    });
  }

  /// Create or update a prompt
  Future<void> upsertPrompt(String? promptID, InteractionType interactionType, String label, {String? venueId, bool? withPreview}) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Upserting prompt${venueId != null ? " for venue: $venueId" : ""}', context: 'ContentManager');

      final payload = {
        'prompt_id': promptID,
        'interaction_type': interactionType.toJson(),
        'label': label,
        if (venueId != null) 'venue_id': venueId,
        if (withPreview != null) 'with_preview': withPreview,
      };

      await client.rpc('upsert_prompt', params: {'payload': payload});

      AppLogger.success('Prompt upserted successfully', context: 'ContentManager');
    });
  }

  /// Toggle prompt preview mode
  Future<void> togglePreview(String promptId, bool withPreview) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Toggling prompt preview for $promptId to: $withPreview', context: 'ContentManager');

      final payload = {
        'prompt_id': promptId,
        'with_preview': withPreview,
      };

      await client.rpc('toggle_preview', params: {'payload': payload});

      AppLogger.success('Prompt preview toggled successfully', context: 'ContentManager');
    });
  }

  /// Insert prompt interaction
  Future<void> insertPromptInteraction(int promptFeedID, String promptID, InteractionType interactionType) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Inserting prompt interaction', context: 'ContentManager');

      final payload = {
        'prompt_feed_id': promptFeedID,
        'prompt_id': promptID,
        'interaction_type': interactionType.toJson(),
      };

      await client.rpc('insert_prompt_interaction', params: {'payload': payload});

      AppLogger.success('Prompt interaction inserted successfully', context: 'ContentManager');
    });
  }

  // MARK: - Admin Features

  /// Fetch pending reviews (admin only)
  Future<List<Prompt>> fetchPendingReviews(PaginatedRequest paginatedRequest) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching pending reviews with pagination: $paginatedRequest', context: 'ContentManager');
      
      // Call the appropriate RPC function based on the list type
      final result = await client
          .rpc(paginatedRequest.list.value, params: {'payload': paginatedRequest.toJson()})
          .select();
      
      AppLogger.success('Pending reviews RPC call successful', context: 'ContentManager');
      AppLogger.debug('Pending reviews raw result: $result', context: 'ContentManager');
      
      // Handle empty result
      if (result.isEmpty) {
        AppLogger.warning('RPC returned empty list', context: 'ContentManager');
        return <Prompt>[];
      }
      
      final resultList = result as List<dynamic>;
      AppLogger.debug('Pending reviews data received: ${resultList.length} prompts', context: 'ContentManager');
      
      // Parse the data as List<Prompt>
      final prompts = resultList
          .map((promptData) => Prompt.fromJson(promptData as Map<String, dynamic>))
          .toList();
      
      AppLogger.success('Prompts parsed: ${prompts.length} prompts', context: 'ContentManager');
      return prompts;
    });
  }

  /// Update prompt status in batch (admin only)
  Future<void> updatePromptStatusBatch(List<String> promptIds, PromptStatus status) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating prompt status for ${promptIds.length} prompts', context: 'ContentManager');
      
      final payload = {
        'prompt_ids': promptIds,
        'status': status.value,
      };
      
      await client.rpc('update_prompt_statuses_batch', params: {'payload': payload});
      
      AppLogger.success('Prompt status batch update completed', context: 'ContentManager');
    });
  }

  /// Update prompt status by review type (admin only)
  Future<void> updatePromptStatusByReviewType(ReviewType reviewType, PromptStatus status) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating prompt status by review type: ${reviewType.name}', context: 'ContentManager');
      
      final payload = {
        'review_type': reviewType.value,
        'status': status.value,
      };
      
      await client.rpc('update_all_prompts_by_review_type', params: {'payload': payload});
      
      AppLogger.success('Prompt status updated by review type', context: 'ContentManager');
    });
  }

  /// Report a prompt for review
  Future<void> reportPrompt(String promptId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Reporting prompt: $promptId', context: 'ContentManager');

      await client.rpc('report_prompt', params: {'p_prompt_id': promptId});

      AppLogger.success('Prompt reported successfully', context: 'ContentManager');
    });
  }

  /// Dispose this manager and clean up resources.
  void dispose() {
    disposeResources('ContentManager');
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!.disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}