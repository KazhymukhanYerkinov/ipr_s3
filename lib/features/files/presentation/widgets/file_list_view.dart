import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_card.dart';

class FileListView extends StatelessWidget {
  final List<SecureFileEntity> files;
  final ValueChanged<SecureFileEntity> onFileTap;
  final ValueChanged<SecureFileEntity> onFileDelete;

  const FileListView({
    super.key,
    required this.files,
    required this.onFileTap,
    required this.onFileDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: files.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final file = files[index];
        return RepaintBoundary(
          child: FileCard(
            file: file,
            onTap: () => onFileTap(file),
            onDelete: () => onFileDelete(file),
          ),
        );
      },
    );
  }
}
