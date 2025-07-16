class Tag {
  final String id;
  final String label;
  final String? icon;
  final String? emoji;
  final bool? isSelected;

  const Tag({
    required this.id,
    required this.label,
    this.icon,
    this.emoji,
    this.isSelected,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String?,
      emoji: json['emoji'] as String?,
      isSelected: json['is_selected'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'emoji': emoji,
      'is_selected': isSelected,
    };
  }

  // Helper methods
  String get displayText {
    if (emoji != null && emoji!.isNotEmpty) {
      return '$emoji $label';
    }
    return label;
  }

  Tag copyWith({
    String? id,
    String? label,
    String? icon,
    String? emoji,
    bool? isSelected,
  }) {
    return Tag(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}