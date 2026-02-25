import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';

class SortBySize implements SortStrategy {
  @override
  String get label => 'By size';

  @override
  List<SecureFileEntity> sort(List<SecureFileEntity> files) =>
      [...files]..sort((a, b) => b.size.compareTo(a.size));
}
