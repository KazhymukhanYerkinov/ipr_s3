import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_file_by_id_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@injectable
class GetFileByIdUseCase implements Callable<String, SecureFileEntity> {
  final GetFileByIdBehavior _behavior;

  GetFileByIdUseCase(this._behavior);

  @override
  Future<Result<SecureFileEntity>> call(String fileId) {
    return _behavior.getFileById(fileId);
  }
}
