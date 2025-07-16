enum PromptStatus {
  draft('draft'),
  pendingReview('pending_review'),
  pendingTranslation('pending_translation'),
  approved('approved'),
  rejected('rejected'),
  archived('archived');

  const PromptStatus(this.value);
  
  final String value;

  static PromptStatus fromJson(String value) {
    return PromptStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PromptStatus.draft,
    );
  }

  String toJson() => value;
}