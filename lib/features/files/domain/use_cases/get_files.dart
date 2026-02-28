import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@injectable
class GetFilesUseCase implements Callable<NoParams, List<SecureFileEntity>> {
  final GetFilesBehavior _behavior;

  GetFilesUseCase(this._behavior);

  @override
  Future<Result<List<SecureFileEntity>>> call([_ = const NoParams()]) {
    return _behavior.getFiles();
  }
}
