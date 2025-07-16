enum MatchStatus {
  matched('matched'),
  connected('connected');

  const MatchStatus(this.value);
  
  final String value;

  static MatchStatus fromJson(String value) {
    return MatchStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MatchStatus.matched,
    );
  }

  String toJson() => value;
}