/// PromptShare model representing a shareable link for a prompt
///
/// This model represents:
/// - A share link with stats about issued and redeemed invite codes
/// - The full share data returned from get_request
class PromptShare {
  /// Unique identifier for the share
  final String? id;

  /// The unique slug for the share link (8 characters, URL-friendly)
  final String slug;

  /// The prompt ID this share belongs to
  final String? promptId;

  /// Number of times this share link has been viewed
  final int? viewCount;

  /// Maximum number of invite codes that can be issued for this share
  final int? maxCodes;

  /// Number of invite codes that have been issued
  final int? codesIssued;

  /// Number of invite codes that have been redeemed
  final int? codesRedeemed;

  /// When this share was created
  final DateTime? createdAt;

  const PromptShare({
    this.id,
    required this.slug,
    this.promptId,
    this.viewCount,
    this.maxCodes,
    this.codesIssued,
    this.codesRedeemed,
    this.createdAt,
  });

  /// Create a PromptShare from the slug returned by create_prompt_share RPC
  factory PromptShare.fromSlug(String slug, String promptId) {
    return PromptShare(
      slug: slug,
      promptId: promptId,
    );
  }

  /// Create a PromptShare from JSON (used when parsing share from get_request)
  factory PromptShare.fromJson(Map<String, dynamic> json) {
    return PromptShare(
      id: json['id'] as String?,
      slug: json['slug'] as String,
      promptId: json['prompt_id'] as String?,
      viewCount: json['view_count'] as int?,
      maxCodes: json['max_codes'] as int?,
      codesIssued: json['codes_issued'] as int?,
      codesRedeemed: json['codes_redeemed'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert PromptShare to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'slug': slug,
      if (promptId != null) 'prompt_id': promptId,
      if (viewCount != null) 'view_count': viewCount,
      if (maxCodes != null) 'max_codes': maxCodes,
      if (codesIssued != null) 'codes_issued': codesIssued,
      if (codesRedeemed != null) 'codes_redeemed': codesRedeemed,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PromptShare(id: $id, slug: $slug, viewCount: $viewCount, codesIssued: $codesIssued, codesRedeemed: $codesRedeemed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PromptShare &&
        other.id == id &&
        other.slug == slug &&
        other.promptId == promptId;
  }

  @override
  int get hashCode {
    return (id?.hashCode ?? 0) ^ slug.hashCode ^ (promptId?.hashCode ?? 0);
  }
}
