import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/folders/data/services/folders_service.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/create_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/delete_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';

@module
abstract class FoldersModule {
  @factoryMethod
  GetFoldersBehavior getFoldersBehavior(FoldersService service) => service;

  @factoryMethod
  CreateFolderBehavior createFolderBehavior(FoldersService service) => service;

  @factoryMethod
  DeleteFolderBehavior deleteFolderBehavior(FoldersService service) => service;
}
