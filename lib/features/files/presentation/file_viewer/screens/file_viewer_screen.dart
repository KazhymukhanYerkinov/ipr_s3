import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/core/widgets/error_state_view.dart';
import 'package:ipr_s3/core/widgets/loading_state_view.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_bloc.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_event.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_state.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/widgets/previews/file_preview_factory.dart';

@RoutePage()
class FileViewerScreen extends StatelessWidget {
  final String fileId;
  final String fileName;

  const FileViewerScreen({
    super.key,
    required this.fileId,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<FileViewerBloc>()..add(FileViewerDecryptRequested(fileId)),
      child: _FileViewerView(fileName: fileName, fileId: fileId),
    );
  }
}

class _FileViewerView extends StatelessWidget {
  final String fileName;
  final String fileId;

  const _FileViewerView({required this.fileName, required this.fileId});

  @override
  Widget build(BuildContext context) {
    final l = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: BlocBuilder<FileViewerBloc, FileViewerState>(
        buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
        builder: (context, state) {
          return switch (state) {
            FileViewerInitial() => const SizedBox.shrink(),
            FileViewerLoading() => LoadingStateView(message: l.decrypting),
            FileViewerLoaded(:final file, :final bytes) =>
              FilePreviewFactory.create(file: file, bytes: bytes),
            FileViewerError(:final message) => ErrorStateView(
              message: message,
              onRetry:
                  () => context.read<FileViewerBloc>().add(
                    FileViewerDecryptRequested(fileId),
                  ),
            ),
          };
        },
      ),
    );
  }
}
