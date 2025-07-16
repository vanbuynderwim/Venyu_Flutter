enum MatchResponse {
  interested('interested'),
  notInterested('not_interested');

  const MatchResponse(this.value);
  final String value;

  static MatchResponse fromString(String value) {
    return MatchResponse.values.firstWhere((e) => e.value == value);
  }
}