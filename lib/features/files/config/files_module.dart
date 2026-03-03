import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/data/services/files_service.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/behaviors/decrypt_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/file_storage_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_file_by_id_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/import_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/search_files_behavior.dart';

@module
abstract class FilesModule {
  @factoryMethod
  GetFilesBehavior getFilesBehavior(FilesService service) => service;

  @factoryMethod
  GetFileByIdBehavior getFileByIdBehavior(FilesService service) => service;

  @factoryMethod
  ImportFileBehavior importFileBehavior(FilesService service) => service;

  @factoryMethod
  DecryptFileBehavior decryptFileBehavior(FilesService service) => service;

  @factoryMethod
  SearchFilesBehavior searchFilesBehavior(FilesService service) => service;

  @factoryMethod
  FileStorageBehavior fileStorageBehavior(FilesLocalSource source) => source;
}
