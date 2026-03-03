import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/files/bloc/thumbnail_cubit.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/file_icon.dart';

class FileThumbnail extends StatefulWidget {
  final String thumbnailPath;
  final FileType fileType;
  final double iconSize;
  final BoxFit fit;

  const FileThumbnail({
    super.key,
    required this.thumbnailPath,
    required this.fileType,
    this.iconSize = 24,
    this.fit = BoxFit.cover,
  });

  @override
  State<FileThumbnail> createState() => _FileThumbnailState();
}

class _FileThumbnailState extends State<FileThumbnail> {
  @override
  void initState() {
    super.initState();
    context.read<ThumbnailCubit>().load(widget.thumbnailPath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThumbnailCubit, Map<String, Uint8List>, Uint8List?>(
      selector: (state) => state[widget.thumbnailPath],
      builder: (context, bytes) {
        if (bytes != null) {
          return Image.memory(
            bytes,
            fit: widget.fit,
            errorBuilder: (_, __, ___) => _fallbackIcon(),
          );
        }
        return _fallbackIcon();
      },
    );
  }

  Widget _fallbackIcon() =>
      Center(child: FileIcon(type: widget.fileType, size: widget.iconSize));
}
