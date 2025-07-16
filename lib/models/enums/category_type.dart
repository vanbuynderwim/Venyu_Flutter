enum CategoryType {
  personal('personal'),
  company('company');

  const CategoryType(this.value);
  
  final String value;

  static CategoryType fromJson(String value) {
    return CategoryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => CategoryType.personal,
    );
  }

  String toJson() => value;
}