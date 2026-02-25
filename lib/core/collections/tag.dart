/// Тег файла с кастомной логикой равенства.
///
/// Два тега считаются одинаковыми, если их [name] совпадают
/// без учёта регистра. Это позволяет использовать [Set<Tag>]
/// для автоматического исключения дубликатов:
///
/// ```dart
/// final tags = <Tag>{Tag('Work'), Tag('work'), Tag('WORK')};
/// print(tags.length); // 1
/// ```
///
/// Кастомные [operator==] и [hashCode] — демонстрация Цели 6.
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
