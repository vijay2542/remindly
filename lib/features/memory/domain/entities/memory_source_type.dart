enum MemorySourceType {
  text('Text'),
  voice('Voice');

  final String label;
  const MemorySourceType(this.label);

  static MemorySourceType fromString(String? value) {
    if (value == null) return MemorySourceType.text;
    return MemorySourceType.values.firstWhere(
      (s) => s.name.toLowerCase() == value.toLowerCase(),
      orElse: () => MemorySourceType.text,
    );
  }
}
