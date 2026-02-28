import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/search_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@injectable
class SearchFilesUseCase implements Callable<String, List<SecureFileEntity>> {
  final SearchFilesBehavior _behavior;

  SearchFilesUseCase(this._behavior);

  @override
  Future<Result<List<SecureFileEntity>>> call(String query) {
    return _behavior.searchFiles(query);
  }
}
