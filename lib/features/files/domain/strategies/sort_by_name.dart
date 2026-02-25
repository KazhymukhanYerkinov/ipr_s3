import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';

class SortByName implements SortStrategy {
  @override
  String get label => 'By name';

  @override
  List<SecureFileEntity> sort(List<SecureFileEntity> files) =>
      [...files]..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
}
