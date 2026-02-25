sealed class FoldersEvent {}

final class FoldersLoadRequested extends FoldersEvent {}

final class FolderCreateRequested extends FoldersEvent {
  final String name;
  final String? parentId;
  FolderCreateRequested({required this.name, this.parentId});
}

final class FolderDeleteRequested extends FoldersEvent {
  final String folderId;
  FolderDeleteRequested(this.folderId);
}

final class FileMovedToFolder extends FoldersEvent {
  final String fileId;
  final String? folderId;
  FileMovedToFolder({required this.fileId, this.folderId});
}
