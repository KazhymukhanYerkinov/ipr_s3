import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';

class SortByType implements SortStrategy {
  @override
  String get label => 'By type';

  @override
  List<SecureFileEntity> sort(List<SecureFileEntity> files) =>
      [...files]..sort((a, b) => a.type.name.compareTo(b.type.name));
}
