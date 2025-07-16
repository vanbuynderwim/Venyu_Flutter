enum MatchStatus {
  matched('matched'),
  connected('connected');

  const MatchStatus(this.value);
  final String value;

  static MatchStatus fromString(String value) {
    return MatchStatus.values.firstWhere((e) => e.value == value);
  }
}