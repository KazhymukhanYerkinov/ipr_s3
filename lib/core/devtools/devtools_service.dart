import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ipr_s3/core/constants/storage_keys.dart';
import 'package:ipr_s3/core/security/encryption_helper.dart';
import 'package:ipr_s3/core/security/pin_manager.dart';
import 'package:ipr_s3/features/files/data/dtos/secure_file_dto.dart';
import 'package:ipr_s3/features/files/domain/commands/command_manager.dart';

class DevToolsService {
  final PinManager _pinManager;
  final EncryptionHelper _encryptionHelper;
  final CommandManager _commandManager;

  DevToolsService(
    this._pinManager,
    this._encryptionHelper,
    this._commandManager,
  );

  void register() {
    if (kReleaseMode) return;

    _registerSecurityStatus();
    _registerCommandHistory();
  }

  void _registerSecurityStatus() {
    registerExtension('ext.filesecure.getSecurityStatus', (
      String method,
      Map<String, String> parameters,
    ) async {
      try {
        final pinSet = await _pinManager.hasPin();

        bool encryptionKeyExists = false;
        try {
          await _encryptionHelper.getEncryptionKey();
          encryptionKeyExists = true;
        } catch (_) {
          encryptionKeyExists = false;
        }

        int encryptedFilesCount = 0;
        if (Hive.isBoxOpen(StorageKeys.secureFilesBox)) {
          final box = Hive.box<SecureFileDto>(StorageKeys.secureFilesBox);
          encryptedFilesCount = box.length;
        }

        int hiveBoxesOpen = 0;
        if (Hive.isBoxOpen(StorageKeys.secureFilesBox)) hiveBoxesOpen++;
        if (Hive.isBoxOpen(StorageKeys.foldersBox)) hiveBoxesOpen++;

        return ServiceExtensionResponse.result(
          jsonEncode({
            'pinSet': pinSet,
            'encryptionKeyExists': encryptionKeyExists,
            'encryptedFilesCount': encryptedFilesCount,
            'hiveBoxesOpen': hiveBoxesOpen,
          }),
        );
      } catch (e) {
        return ServiceExtensionResponse.error(
          ServiceExtensionResponse.extensionError,
          e.toString(),
        );
      }
    });
  }

  void _registerCommandHistory() {
    registerExtension('ext.filesecure.getCommandHistory', (
      String method,
      Map<String, String> parameters,
    ) async {
      try {
        return ServiceExtensionResponse.result(
          jsonEncode({
            'undoStack': _commandManager.undoDescriptions,
            'redoStack': _commandManager.redoDescriptions,
          }),
        );
      } catch (e) {
        return ServiceExtensionResponse.error(
          ServiceExtensionResponse.extensionError,
          e.toString(),
        );
      }
    });
  }
}
