/// Command pattern — абстрактная команда над файлом.
///
/// Каждая команда инкапсулирует действие и его отмену.
/// [execute] выполняет действие, [undo] откатывает.
/// [description] — человекочитаемое описание для UI (SnackBar, история).
abstract class FileCommand {
  String get description;
  Future<void> execute();
  Future<void> undo();
}
