import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

sealed class FilesEvent {}

final class FilesLoadRequested extends FilesEvent {}

final class FileImportRequested extends FilesEvent {}

final class FileDeleteRequested extends FilesEvent {
  final SecureFileEntity file;
  FileDeleteRequested(this.file);
}

final class FileSearchRequested extends FilesEvent {
  final String query;
  FileSearchRequested(this.query);
}

final class FileSearchCleared extends FilesEvent {}

final class ViewModeToggled extends FilesEvent {}
