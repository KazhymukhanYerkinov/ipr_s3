// ignore_for_file: unused_import
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

/// Retrofit-based type-safe API client for the Files feature.
///
/// Currently a placeholder — once a backend is available and
/// `retrofit_generator` is enabled in pubspec.yaml:
/// 1. Uncomment `part 'files_api_client.g.dart';`
/// 2. Uncomment the `@RestApi()` annotation and factory
/// 3. Uncomment the endpoint methods
/// 4. Run `dart run build_runner build`
///
/// Usage in a remote source:
/// ```dart
/// final client = FilesApiClient(apiClient.dio);
/// final files = await client.getFiles();
/// ```
// @RestApi()
abstract class FilesApiClient {
  // factory FilesApiClient(Dio dio, {String baseUrl}) = _FilesApiClient;

  // @GET('/api/files')
  // Future<List<dynamic>> getFiles();

  // @GET('/api/files/{id}')
  // Future<dynamic> getFileById(@Path('id') String id);

  // @POST('/api/files')
  // @MultiPart()
  // Future<dynamic> uploadFile(@Part() File file);

  // @DELETE('/api/files/{id}')
  // Future<void> deleteFile(@Path('id') String id);
}
