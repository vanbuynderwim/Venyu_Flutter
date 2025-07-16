enum CategoryType {
  personal('personal'),
  company('company');

  const CategoryType(this.value);
  final String value;

  static CategoryType fromString(String value) {
    return CategoryType.values.firstWhere((e) => e.value == value);
  }
}