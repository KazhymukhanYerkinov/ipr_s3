import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/folders/data/repositories/folders_repository_impl.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/create_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/delete_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/move_file_to_folder_behavior.dart';

@module
abstract class FoldersModule {
  @factoryMethod
  GetFoldersBehavior getFoldersBehavior(FoldersRepositoryImpl repository) =>
      repository;

  @factoryMethod
  CreateFolderBehavior createFolderBehavior(FoldersRepositoryImpl repository) =>
      repository;

  @factoryMethod
  DeleteFolderBehavior deleteFolderBehavior(FoldersRepositoryImpl repository) =>
      repository;

  @factoryMethod
  MoveFileToFolderBehavior moveFileToFolderBehavior(
    FoldersRepositoryImpl repository,
  ) => repository;
}
