/// ScoreDetail - Represents a single score component with its breakdown
///
/// Contains information about a specific scoring component including:
/// - Unique identifier
/// - Icon for UI display
/// - Localized label and description
/// - Weighted points (can be null if no data available)
class ScoreDetail {
  final String id;
  final String icon;
  final String label;
  final String description;
  final double? weightedPoints;

  const ScoreDetail({
    required this.id,
    required this.icon,
    required this.label,
    required this.description,
    this.weightedPoints,
  });

  factory ScoreDetail.fromJson(Map<String, dynamic> json) {
    return ScoreDetail(
      id: json['id'] as String,
      icon: json['icon'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      weightedPoints: (json['score_points'] ?? json['weighted_points']) != null
          ? ((json['score_points'] ?? json['weighted_points']) as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'label': label,
      'description': description,
      'weighted_points': weightedPoints,
    };
  }

  /// Whether this component has score data available
  bool get hasData => weightedPoints != null;

  ScoreDetail copyWith({
    String? id,
    String? icon,
    String? label,
    String? description,
    double? weightedPoints,
  }) {
    return ScoreDetail(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      description: description ?? this.description,
      weightedPoints: weightedPoints ?? this.weightedPoints,
    );
  }
}
