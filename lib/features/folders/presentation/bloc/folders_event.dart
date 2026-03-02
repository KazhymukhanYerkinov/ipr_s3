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
