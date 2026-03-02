import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/grid_card.dart';

class FileGrid extends StatelessWidget {
  final List<SecureFileEntity> files;
  final ValueChanged<SecureFileEntity> onFileTap;
  final ValueChanged<SecureFileEntity> onFileDelete;

  const FileGrid({
    super.key,
    required this.files,
    required this.onFileTap,
    required this.onFileDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: files.length,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final file = files[index];
        return RepaintBoundary(
          key: ValueKey(file.id),
          child: GridCard(
            file: file,
            onTap: () => onFileTap(file),
            onDelete: () => onFileDelete(file),
          ),
        );
      },
    );
  }
}
