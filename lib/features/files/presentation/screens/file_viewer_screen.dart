import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/use_cases/decrypt_file.dart';
import 'package:ipr_s3/features/files/domain/use_cases/get_files.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/file_preview_factory.dart';

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
    filesResult.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        }
      },
      (files) async {
        final file = files.where((f) => f.id == widget.fileId).firstOrNull;
        if (file == null) {
          if (mounted) {
            setState(() {
              _error = 'File not found';
              _isLoading = false;
            });
          }
          return;
        }

        _file = file;

        final decryptResult = await getIt<DecryptFileUseCase>()(widget.fileId);
        if (mounted) {
          decryptResult.fold(
            (failure) => setState(() {
              _error = failure.message;
              _isLoading = false;
            }),
            (bytes) => setState(() {
              _decryptedBytes = bytes;
              _isLoading = false;
            }),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Decrypting...',
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
            Icon(Icons.error_outline_rounded,
                size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(_error!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadAndDecrypt,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_file != null && _decryptedBytes != null) {
      return FilePreviewFactory.create(
        file: _file!,
        bytes: _decryptedBytes!,
      );
    }

    return const SizedBox.shrink();
  }
}
