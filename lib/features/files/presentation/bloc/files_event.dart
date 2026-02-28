import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';

sealed class FilesEvent {}

final class FilesLoadRequested extends FilesEvent {}

final class FileImportRequested extends FilesEvent {
  final String? folderId;
  FileImportRequested({this.folderId});
}

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

final class SortStrategyChanged extends FilesEvent {
  final SortStrategy strategy;
  SortStrategyChanged(this.strategy);
}
