enum Category {
  home('Home'),
  family('Family'),
  work('Work'),
  vehicle('Vehicle'),
  shopping('Shopping'),
  travel('Travel'),
  documents('Documents'),
  other('Other');

  final String label;
  const Category(this.label);

  static Category fromString(String? value) {
    if (value == null) return Category.other;
    return Category.values.firstWhere(
      (c) => c.name.toLowerCase() == value.toLowerCase() || c.label.toLowerCase() == value.toLowerCase(),
      orElse: () => Category.other,
    );
  }
}
