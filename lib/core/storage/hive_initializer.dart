import 'package:hive_flutter/hive_flutter.dart';
import 'package:ipr_s3/features/files/data/dtos/secure_file_dto.dart';
import 'package:ipr_s3/features/folders/data/dtos/folder_dto.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SecureFileDtoAdapter());
  Hive.registerAdapter(FolderDtoAdapter());
}
