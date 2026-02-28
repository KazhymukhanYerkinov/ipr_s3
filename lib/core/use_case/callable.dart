import 'package:ipr_s3/core/result/result.dart';

abstract class Callable<Params, T> {
  Future<Result<T>> call(Params params);
}

class NoParams {
  const NoParams();
}
