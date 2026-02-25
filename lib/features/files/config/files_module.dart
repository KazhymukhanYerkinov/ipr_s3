import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/data/repositories/files_repository_impl.dart';
import 'package:ipr_s3/features/files/domain/behaviors/decrypt_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/delete_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/import_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/search_files_behavior.dart';

@module
abstract class FilesModule {
  @factoryMethod
  GetFilesBehavior getFilesBehavior(FilesRepositoryImpl repository) =>
      repository;

  @factoryMethod
  ImportFileBehavior importFileBehavior(FilesRepositoryImpl repository) =>
      repository;

  @factoryMethod
  DecryptFileBehavior decryptFileBehavior(FilesRepositoryImpl repository) =>
      repository;

  @factoryMethod
  DeleteFileBehavior deleteFileBehavior(FilesRepositoryImpl repository) =>
      repository;

  @factoryMethod
  SearchFilesBehavior searchFilesBehavior(FilesRepositoryImpl repository) =>
      repository;
}
