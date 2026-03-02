sealed class FileViewerEvent {}

final class FileViewerDecryptRequested extends FileViewerEvent {
  final String fileId;
  FileViewerDecryptRequested(this.fileId);
}
