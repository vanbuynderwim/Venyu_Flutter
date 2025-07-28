/// Defines the category context for tag groups and profile information.
/// 
/// Used to distinguish between personal and company-related data
/// when organizing user profiles and tag classifications.
/// 
/// Example usage:
/// ```dart
/// // Fetch personal tag groups
/// final personalTags = await supabase.fetchTagGroups(CategoryType.personal);
/// 
/// // Fetch company tag groups
/// final companyTags = await supabase.fetchTagGroups(CategoryType.company);
/// ```
enum CategoryType {
  /// Personal/individual profile information and tags.
  personal('personal'),
  
  /// Company/organizational profile information and tags.
  company('company');

  const CategoryType(this.value);
  
  final String value;

  /// Creates a [CategoryType] from a JSON string value.
  /// 
  /// Returns [CategoryType.personal] if the value doesn't match any type.
  static CategoryType fromJson(String value) {
    return CategoryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => CategoryType.personal,
    );
  }

  /// Converts this [CategoryType] to a JSON string value.
  String toJson() => value;
}