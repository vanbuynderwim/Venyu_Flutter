enum PromptStatus {
  draft('draft'),
  pendingReview('pending_review'),
  pendingTranslation('pending_translation'),
  approved('approved'),
  rejected('rejected'),
  archived('archived');

  const PromptStatus(this.value);
  final String value;

  static PromptStatus fromString(String value) {
    return PromptStatus.values.firstWhere((e) => e.value == value);
  }
}