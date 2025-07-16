enum InteractionType {
  thisIsMe('this_is_me'),
  lookingForThis('looking_for_this'),
  knowSomeone('know_someone'),
  notRelevant('not_relevant');

  const InteractionType(this.value);
  
  final String value;

  static InteractionType fromJson(String value) {
    return InteractionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => InteractionType.thisIsMe,
    );
  }

  String toJson() => value;
}