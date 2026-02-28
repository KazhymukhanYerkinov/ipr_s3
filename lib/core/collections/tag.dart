class Tag {
  final String name;

  const Tag(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && name.toLowerCase() == other.name.toLowerCase();

  @override
  int get hashCode => name.toLowerCase().hashCode;

  @override
  String toString() => name;
}
