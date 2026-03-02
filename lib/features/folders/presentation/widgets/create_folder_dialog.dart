import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_bloc.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_event.dart';

Future<void> showCreateFolderDialog(BuildContext context, {String? parentId}) {
  final l = context.locale;
  final controller = TextEditingController();

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(parentId != null ? l.newSubfolder : l.newFolder),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l.folderName,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<FoldersBloc>().add(
                  FolderCreateRequested(name: name, parentId: parentId),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: Text(l.create),
          ),
        ],
      );
    },
  );
}
