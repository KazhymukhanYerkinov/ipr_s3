import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';

class SortByDate implements SortStrategy {
  @override
  String get label => 'By date';

  @override
  List<SecureFileEntity> sort(List<SecureFileEntity> files) =>
      [...files]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
