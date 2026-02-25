// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(fileName) => "Encrypting ${fileName}...";

  static String m1(fileName) =>
      "This will permanently delete \"${fileName}\".";

  static String m2(folderName) =>
      "This will permanently delete \"${folderName}\" and all subfolders.";

  static String m3(completed, total) => "${completed} of ${total} files";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addTag": MessageLookupByLibrary.simpleMessage("Add Tag"),
        "addTagChip": MessageLookupByLibrary.simpleMessage("Add tag"),
        "allFilesEncrypted":
            MessageLookupByLibrary.simpleMessage("All files encrypted!"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Secure App"),
        "benchmarkTitle":
            MessageLookupByLibrary.simpleMessage("Benchmark: Dart vs C (FFI)"),
        "biometricReason": MessageLookupByLibrary.simpleMessage(
            "Confirm to unlock File Secure"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changePin": MessageLookupByLibrary.simpleMessage("Change PIN"),
        "confirmPin": MessageLookupByLibrary.simpleMessage("Confirm PIN"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createFourDigitCode":
            MessageLookupByLibrary.simpleMessage("Create a 4-digit code"),
        "currentPin": MessageLookupByLibrary.simpleMessage("Current PIN"),
        "decrypting": MessageLookupByLibrary.simpleMessage("Decrypting..."),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteFileContent": m1,
        "deleteFileTitle":
            MessageLookupByLibrary.simpleMessage("Delete file?"),
        "deleteFolderContent": m2,
        "deleteFolderTitle":
            MessageLookupByLibrary.simpleMessage("Delete folder?"),
        "device": MessageLookupByLibrary.simpleMessage("Device"),
        "encryptingFile": m0,
        "enterPin": MessageLookupByLibrary.simpleMessage("Enter PIN"),
        "enterPinAgain":
            MessageLookupByLibrary.simpleMessage("Enter PIN again"),
        "fileNotFound": MessageLookupByLibrary.simpleMessage("File not found"),
        "fileSecure": MessageLookupByLibrary.simpleMessage("File Secure"),
        "filesProgress": m3,
        "folderName": MessageLookupByLibrary.simpleMessage("Folder name"),
        "folders": MessageLookupByLibrary.simpleMessage("Folders"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "importingFiles":
            MessageLookupByLibrary.simpleMessage("Importing Files"),
        "largestFiles": MessageLookupByLibrary.simpleMessage("Largest Files"),
        "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
        "logOutConfirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to log out?"),
        "logOutTitle": MessageLookupByLibrary.simpleMessage("Log out?"),
        "newFolder": MessageLookupByLibrary.simpleMessage("New Folder"),
        "newPin": MessageLookupByLibrary.simpleMessage("New PIN"),
        "newSubfolder": MessageLookupByLibrary.simpleMessage("New Subfolder"),
        "noFilesYet": MessageLookupByLibrary.simpleMessage("No files yet"),
        "noPinSet": MessageLookupByLibrary.simpleMessage("No PIN set"),
        "pinIsSet": MessageLookupByLibrary.simpleMessage("PIN is set"),
        "pinMismatch": MessageLookupByLibrary.simpleMessage(
            "PINs don\'t match. Try again"),
        "preparing": MessageLookupByLibrary.simpleMessage("Preparing..."),
        "recentFiles": MessageLookupByLibrary.simpleMessage("Recent Files"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "searchFiles": MessageLookupByLibrary.simpleMessage("Search files..."),
        "security": MessageLookupByLibrary.simpleMessage("Security"),
        "securityEncryptedData": MessageLookupByLibrary.simpleMessage(
            "✓ Local data encrypted (Hive + AES-256)"),
        "securityFeatures":
            MessageLookupByLibrary.simpleMessage("Security Features"),
        "securityHttpsOnly":
            MessageLookupByLibrary.simpleMessage("✓ HTTPS only (Firebase SDK)"),
        "securityMaskedLogs": MessageLookupByLibrary.simpleMessage(
            "✓ Sensitive data masked in logs"),
        "securityOAuth": MessageLookupByLibrary.simpleMessage(
            "✓ OAuth 2.0 via Google Sign-In"),
        "securityTokenStorage": MessageLookupByLibrary.simpleMessage(
            "✓ Token in Secure Storage (Keychain/EncryptedSP)"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "setupPin": MessageLookupByLibrary.simpleMessage("Set up PIN"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "Protected with OWASP standards"),
        "signInWithGoogle":
            MessageLookupByLibrary.simpleMessage("Sign in with Google"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
        "tagName": MessageLookupByLibrary.simpleMessage("Tag name"),
        "tapToImport": MessageLookupByLibrary.simpleMessage(
            "Tap + to import and encrypt your first file"),
        "wrongPin": MessageLookupByLibrary.simpleMessage("Wrong PIN")
      };
}
