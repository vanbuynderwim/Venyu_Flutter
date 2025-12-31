import 'package:flutter/material.dart';

import 'profile.dart';
import 'venue.dart';
import 'match.dart';
import 'prompt_share.dart';
import 'enums/prompt_status.dart';
import 'enums/interaction_type.dart';

class Prompt {
  final int? feedID;
  final String promptID;
  final String label;
  final PromptStatus? status;
  final DateTime? createdAt;
  final DateTime? reviewedAt;
  final int? impressionCount;
  final InteractionType? interactionType;
  final InteractionType? userInteractionType;
  final InteractionType? matchInteractionType;
  final Profile? profile;
  final Venue? venue;
  
  /// Number of matches associated with this prompt (optional).
  /// This is populated when fetching detailed prompt information.
  final int? matchCount;
  
  /// Number of connections associated with this prompt (optional).
  /// This is populated when fetching detailed prompt information.
  final int? connectionCount;

  /// Whether the current user is the author of this prompt (optional).
  final bool? fromAuthor;

  /// Whether this prompt is paused (optional).
  final bool? isPaused;

  /// Whether this prompt has new (unviewed) matches (optional).
  final bool? hasNewMatches;

  /// List of matches associated with this prompt (optional).
  /// This is populated when fetching detailed prompt information via get_request.
  final List<Match>? matches;

  /// Share associated with this prompt (optional).
  /// This is populated for know_someone prompts when fetching via get_request.
  final PromptShare? share;

  const Prompt({
    this.feedID,
    required this.promptID,
    required this.label,
    this.status,
    this.createdAt,
    this.reviewedAt,
    this.impressionCount,
    this.interactionType,
    this.userInteractionType,
    this.matchInteractionType,
    this.profile,
    this.venue,
    this.matchCount,
    this.connectionCount,
    this.fromAuthor,
    this.isPaused,
    this.hasNewMatches,
    this.matches,
    this.share,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      feedID: json['feed_id'] as int?,
      promptID: json['prompt_id'] as String,
      label: json['label'] as String,
      status: json['status'] != null ? PromptStatus.fromJson(json['status']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at']) : null,
      impressionCount: json['impression_count'] as int?,
      interactionType: json['interaction_type'] != null
          ? InteractionType.fromJson(json['interaction_type'])
          : null,
      userInteractionType: json['user_interaction_type'] != null
          ? InteractionType.fromJson(json['user_interaction_type'])
          : null,
      matchInteractionType: json['match_interaction_type'] != null
          ? InteractionType.fromJson(json['match_interaction_type'])
          : null,
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      matchCount: json['match_count'] != null 
          ? (json['match_count'] as num).toInt() 
          : null,
      connectionCount: json['connection_count'] != null
          ? (json['connection_count'] as num).toInt()
          : null,
      fromAuthor: json['from_author'] as bool?,
      isPaused: json['is_paused'] as bool?,
      hasNewMatches: json['has_new_matches'] as bool?,
      matches: json['matches'] != null
          ? (json['matches'] as List<dynamic>)
              .map((m) => Match.fromJson(m as Map<String, dynamic>))
              .toList()
          : null,
      share: json['share'] != null
          ? PromptShare.fromJson(json['share'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feed_id': feedID,
      'prompt_id': promptID,
      'label': label,
      'status': status?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
      'impression_count': impressionCount,
      'interaction_type': interactionType?.toJson(),
      'user_interaction_type': userInteractionType?.toJson(),
      'match_interaction_type': matchInteractionType?.toJson(),
      'profile': profile?.toJson(),
      'venue': venue?.toJson(),
      if (matchCount != null) 'match_count': matchCount,
      if (connectionCount != null) 'connection_count': connectionCount,
      'from_author': fromAuthor,
      'is_paused': isPaused,
      'has_new_matches': hasNewMatches,
      if (matches != null) 'matches': matches!.map((m) => m.toJson()).toList(),
      if (share != null) 'share': share!.toJson(),
    };
  }

  // Helper methods
  bool get isApproved => status == PromptStatus.approved;
  bool get isPending => status == PromptStatus.pendingReview;
  bool get isRejected => status == PromptStatus.rejected;

  /// Get the display status for the UI - just returns the actual status
  PromptStatus get displayStatus {
    return status ?? PromptStatus.draft;
  }

  /// Build the full prompt title combining interaction type prefix and label.
  ///
  /// If [matchFirstName] is provided and [matchInteractionType] is available,
  /// uses promptTitle format: "{firstName} is iemand {label}"
  /// Otherwise falls back to selectionTitle format: "Ik zoek iemand {label}"
  /// If no interaction type is available, returns just the label.
  ///
  /// If [compact] is true, uses a shorter format without the label:
  /// "{firstName} is dit", "{firstName} zoekt dit", "{firstName} kent iemand"
  String buildTitle(BuildContext context, {String? matchFirstName, bool compact = false}) {
    if (matchFirstName != null && matchInteractionType != null) {
      if (compact) {
        return matchInteractionType!.compactPromptTitle(context, matchFirstName);
      }
      return '${matchInteractionType!.promptTitle(context, matchFirstName)} $label';
    } else if (interactionType != null) {
      return '${interactionType!.selectionTitle(context)} $label';
    }
    return label;
  }
}