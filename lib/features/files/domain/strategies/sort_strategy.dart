import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class SortStrategy {
  String get label;
  List<SecureFileEntity> sort(List<SecureFileEntity> files);
}
