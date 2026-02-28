import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ipr_s3/core/collections/tag.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/use_cases/decrypt_file.dart';
import 'package:ipr_s3/features/files/domain/use_cases/get_files.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/file_preview_factory.dart';
import 'package:ipr_s3/features/files/presentation/widgets/tag_chips_widget.dart';

@RoutePage()
class FileViewerScreen extends StatefulWidget {
  final String fileId;
  final String fileName;

  const FileViewerScreen({
    super.key,
    required this.fileId,
    required this.fileName,
  });

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  Uint8List? _decryptedBytes;
  SecureFileEntity? _file;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAndDecrypt();
  }

  @override
  void dispose() {
    _decryptedBytes = null;
    super.dispose();
  }

  Future<void> _loadAndDecrypt() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final filesResult = await getIt<GetFilesUseCase>()();
    final filesFailure = filesResult.failure;

    if (filesFailure != null) {
      if (mounted) {
        setState(() {
          _error = filesFailure.message;
          _isLoading = false;
        });
      }
      return;
    }

    final files = filesResult.value ?? [];
    final file = files.where((f) => f.id == widget.fileId).firstOrNull;
    if (file == null) {
      if (mounted) {
        setState(() {
          _error = context.locale.fileNotFound;
          _isLoading = false;
        });
      }
      return;
    }

    _file = file;

    final decryptResult = await getIt<DecryptFileUseCase>()(widget.fileId);
    if (mounted) {
      final decryptFailure = decryptResult.failure;
      if (decryptFailure != null) {
        setState(() {
          _error = decryptFailure.message;
          _isLoading = false;
        });
      } else {
        setState(() {
          _decryptedBytes = decryptResult.value;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final l = context.locale;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              l.decrypting,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(_error!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadAndDecrypt,
              child: Text(l.retry),
            ),
          ],
        ),
      );
    }

    if (_file != null && _decryptedBytes != null) {
      return Column(
        children: [
          Expanded(
            child: FilePreviewFactory.create(
              file: _file!,
              bytes: _decryptedBytes!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TagChipsWidget(
              tags: _file!.tags.map(Tag.new).toSet(),
              onTagsChanged: _onTagsChanged,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _onTagsChanged(Set<Tag> tags) async {
    if (_file == null) return;
    final tagStrings = tags.map((t) => t.name).toList();
    final updated = _file!.copyWith(
      tags: tagStrings,
      updatedAt: DateTime.now(),
    );
    await getIt<FilesLocalSource>().save(updated);
    setState(() => _file = updated);
  }
}
