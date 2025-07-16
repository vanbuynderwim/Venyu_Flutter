enum FeedbackType {
  linkedinConnected('linkedin_connected'),
  conversationStarted('conversation_started'),
  meetingScheduled('meeting_scheduled'),
  metIrl('met_irl'),
  goodConnection('good_connection'),
  collaborationStarted('collaboration_started'),
  businessOpportunity('business_opportunity'),
  referralMade('referral_made'),
  mentorshipStarted('mentorship_started'),
  badConnection('bad_connection'),
  notRelevant('not_relevant'),
  inappropriateBehavior('inappropriate_behavior'),
  inactiveConnection('inactive_connection');

  const FeedbackType(this.value);
  
  final String value;

  static FeedbackType fromJson(String value) {
    return FeedbackType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FeedbackType.goodConnection,
    );
  }

  String toJson() => value;

  // Helper methods
  bool get isPositive {
    switch (this) {
      case FeedbackType.linkedinConnected:
      case FeedbackType.conversationStarted:
      case FeedbackType.meetingScheduled:
      case FeedbackType.metIrl:
      case FeedbackType.goodConnection:
      case FeedbackType.collaborationStarted:
      case FeedbackType.businessOpportunity:
      case FeedbackType.referralMade:
      case FeedbackType.mentorshipStarted:
        return true;
      default:
        return false;
    }
  }

  bool get isNegative => !isPositive;
}