import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

/// Strategy pattern — интерфейс для сортировки файлов.
///
/// Позволяет менять алгоритм сортировки в runtime без изменения
/// клиентского кода (FilesBloc). Новые стратегии добавляются через
/// новый класс — Open/Closed Principle.
abstract class SortStrategy {
  String get label;
  List<SecureFileEntity> sort(List<SecureFileEntity> files);
}
