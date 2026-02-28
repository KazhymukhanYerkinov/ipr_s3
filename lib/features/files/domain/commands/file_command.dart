abstract class FileCommand {
  String get description;
  Future<void> execute();
  Future<void> undo();
}
