enum MatchResponse {
  interested('interested'),
  notInterested('not_interested');

  const MatchResponse(this.value);
  
  final String value;

  static MatchResponse fromJson(String value) {
    return MatchResponse.values.firstWhere(
      (response) => response.value == value,
      orElse: () => MatchResponse.interested,
    );
  }

  String toJson() => value;
}