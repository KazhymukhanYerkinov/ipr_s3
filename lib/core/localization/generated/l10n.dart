// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class GeneratedLocalization {
  GeneratedLocalization();

  static GeneratedLocalization? _current;

  static GeneratedLocalization get current {
    assert(
      _current != null,
      'No instance of GeneratedLocalization was loaded. Try to initialize the GeneratedLocalization delegate before accessing GeneratedLocalization.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<GeneratedLocalization> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = GeneratedLocalization();
      GeneratedLocalization._current = instance;

      return instance;
    });
  }

  static GeneratedLocalization of(BuildContext context) {
    final instance = GeneratedLocalization.maybeOf(context);
    assert(
      instance != null,
      'No instance of GeneratedLocalization present in the widget tree. Did you add GeneratedLocalization.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static GeneratedLocalization? maybeOf(BuildContext context) {
    return Localizations.of<GeneratedLocalization>(
      context,
      GeneratedLocalization,
    );
  }

  /// `Secure App`
  String get appTitle {
    return Intl.message(
      'Secure App',
      name: 'appTitle',
      desc: 'Application title',
      args: [],
    );
  }

  /// `Protected with OWASP standards`
  String get signInSubtitle {
    return Intl.message(
      'Protected with OWASP standards',
      name: 'signInSubtitle',
      desc: 'Subtitle on the sign-in screen',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: 'Google sign-in button label',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home screen app bar title',
      args: [],
    );
  }

  /// `Security Features`
  String get securityFeatures {
    return Intl.message(
      'Security Features',
      name: 'securityFeatures',
      desc: 'Security features card title',
      args: [],
    );
  }

  /// `✓ Token in Secure Storage (Keychain/EncryptedSP)`
  String get securityTokenStorage {
    return Intl.message(
      '✓ Token in Secure Storage (Keychain/EncryptedSP)',
      name: 'securityTokenStorage',
      desc: 'Security feature: token storage',
      args: [],
    );
  }

  /// `✓ HTTPS only (Firebase SDK)`
  String get securityHttpsOnly {
    return Intl.message(
      '✓ HTTPS only (Firebase SDK)',
      name: 'securityHttpsOnly',
      desc: 'Security feature: HTTPS',
      args: [],
    );
  }

  /// `✓ OAuth 2.0 via Google Sign-In`
  String get securityOAuth {
    return Intl.message(
      '✓ OAuth 2.0 via Google Sign-In',
      name: 'securityOAuth',
      desc: 'Security feature: OAuth',
      args: [],
    );
  }

  /// `✓ Sensitive data masked in logs`
  String get securityMaskedLogs {
    return Intl.message(
      '✓ Sensitive data masked in logs',
      name: 'securityMaskedLogs',
      desc: 'Security feature: masked logs',
      args: [],
    );
  }

  /// `✓ Local data encrypted (Hive + AES-256)`
  String get securityEncryptedData {
    return Intl.message(
      '✓ Local data encrypted (Hive + AES-256)',
      name: 'securityEncryptedData',
      desc: 'Security feature: encrypted data',
      args: [],
    );
  }

  /// `Enter PIN`
  String get enterPin {
    return Intl.message(
      'Enter PIN',
      name: 'enterPin',
      desc: 'Lock screen title',
      args: [],
    );
  }

  /// `Set up PIN`
  String get setupPin {
    return Intl.message(
      'Set up PIN',
      name: 'setupPin',
      desc: 'Set PIN screen title — first step',
      args: [],
    );
  }

  /// `Confirm PIN`
  String get confirmPin {
    return Intl.message(
      'Confirm PIN',
      name: 'confirmPin',
      desc: 'Set PIN screen title — confirmation step',
      args: [],
    );
  }

  /// `Enter PIN again`
  String get enterPinAgain {
    return Intl.message(
      'Enter PIN again',
      name: 'enterPinAgain',
      desc: 'Set PIN screen subtitle — confirmation step',
      args: [],
    );
  }

  /// `Create a 4-digit code`
  String get createFourDigitCode {
    return Intl.message(
      'Create a 4-digit code',
      name: 'createFourDigitCode',
      desc: 'Set PIN screen subtitle — first step',
      args: [],
    );
  }

  /// `PINs don't match. Try again`
  String get pinMismatch {
    return Intl.message(
      'PINs don\'t match. Try again',
      name: 'pinMismatch',
      desc: 'Error when confirmation PIN doesn\'t match',
      args: [],
    );
  }

  /// `File Secure`
  String get fileSecure {
    return Intl.message(
      'File Secure',
      name: 'fileSecure',
      desc: 'Main app bar title on home screen',
      args: [],
    );
  }

  /// `Folders`
  String get folders {
    return Intl.message(
      'Folders',
      name: 'folders',
      desc: 'Folders menu item and screen title',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: 'Statistics menu item and screen title',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: 'Settings menu item and screen title',
      args: [],
    );
  }

  /// `Encrypting {fileName}...`
  String encryptingFile(String fileName) {
    return Intl.message(
      'Encrypting $fileName...',
      name: 'encryptingFile',
      desc: 'Status text while encrypting a file',
      args: [fileName],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: 'Generic error message',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: 'Retry button label',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel button label',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: 'Delete button label',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: 'Save button label',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: 'Create button label',
      args: [],
    );
  }

  /// `Delete file?`
  String get deleteFileTitle {
    return Intl.message(
      'Delete file?',
      name: 'deleteFileTitle',
      desc: 'Delete file confirmation dialog title',
      args: [],
    );
  }

  /// `This will permanently delete "{fileName}".`
  String deleteFileContent(String fileName) {
    return Intl.message(
      'This will permanently delete "$fileName".',
      name: 'deleteFileContent',
      desc: 'Delete file confirmation dialog content',
      args: [fileName],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: 'Log out button label',
      args: [],
    );
  }

  /// `Log out?`
  String get logOutTitle {
    return Intl.message(
      'Log out?',
      name: 'logOutTitle',
      desc: 'Log out confirmation dialog title',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logOutConfirm {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logOutConfirm',
      desc: 'Log out confirmation dialog content',
      args: [],
    );
  }

  /// `Device`
  String get device {
    return Intl.message(
      'Device',
      name: 'device',
      desc: 'Device section header in settings',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message(
      'Security',
      name: 'security',
      desc: 'Security section header in settings',
      args: [],
    );
  }

  /// `Change PIN`
  String get changePin {
    return Intl.message(
      'Change PIN',
      name: 'changePin',
      desc: 'Change PIN dialog title and list tile',
      args: [],
    );
  }

  /// `Current PIN`
  String get currentPin {
    return Intl.message(
      'Current PIN',
      name: 'currentPin',
      desc: 'Current PIN text field label',
      args: [],
    );
  }

  /// `New PIN`
  String get newPin {
    return Intl.message(
      'New PIN',
      name: 'newPin',
      desc: 'New PIN text field label',
      args: [],
    );
  }

  /// `PIN is set`
  String get pinIsSet {
    return Intl.message(
      'PIN is set',
      name: 'pinIsSet',
      desc: 'Subtitle when PIN is configured',
      args: [],
    );
  }

  /// `No PIN set`
  String get noPinSet {
    return Intl.message(
      'No PIN set',
      name: 'noPinSet',
      desc: 'Subtitle when PIN is not configured',
      args: [],
    );
  }

  /// `New Folder`
  String get newFolder {
    return Intl.message(
      'New Folder',
      name: 'newFolder',
      desc: 'New folder dialog title',
      args: [],
    );
  }

  /// `New Subfolder`
  String get newSubfolder {
    return Intl.message(
      'New Subfolder',
      name: 'newSubfolder',
      desc: 'New subfolder dialog title',
      args: [],
    );
  }

  /// `Folder name`
  String get folderName {
    return Intl.message(
      'Folder name',
      name: 'folderName',
      desc: 'Folder name text field hint',
      args: [],
    );
  }

  /// `Delete folder?`
  String get deleteFolderTitle {
    return Intl.message(
      'Delete folder?',
      name: 'deleteFolderTitle',
      desc: 'Delete folder confirmation dialog title',
      args: [],
    );
  }

  /// `This will permanently delete "{folderName}" and all subfolders.`
  String deleteFolderContent(String folderName) {
    return Intl.message(
      'This will permanently delete "$folderName" and all subfolders.',
      name: 'deleteFolderContent',
      desc: 'Delete folder confirmation dialog content',
      args: [folderName],
    );
  }

  /// `Recent Files`
  String get recentFiles {
    return Intl.message(
      'Recent Files',
      name: 'recentFiles',
      desc: 'Recent files card title in statistics',
      args: [],
    );
  }

  /// `Largest Files`
  String get largestFiles {
    return Intl.message(
      'Largest Files',
      name: 'largestFiles',
      desc: 'Largest files card title in statistics',
      args: [],
    );
  }

  /// `Decrypting...`
  String get decrypting {
    return Intl.message(
      'Decrypting...',
      name: 'decrypting',
      desc: 'Status text while decrypting a file',
      args: [],
    );
  }

  /// `File not found`
  String get fileNotFound {
    return Intl.message(
      'File not found',
      name: 'fileNotFound',
      desc: 'Error when file is not found',
      args: [],
    );
  }

  /// `Importing Files`
  String get importingFiles {
    return Intl.message(
      'Importing Files',
      name: 'importingFiles',
      desc: 'Import progress screen title',
      args: [],
    );
  }

  /// `{completed} of {total} files`
  String filesProgress(int completed, int total) {
    return Intl.message(
      '$completed of $total files',
      name: 'filesProgress',
      desc: 'Import progress counter',
      args: [completed, total],
    );
  }

  /// `All files encrypted!`
  String get allFilesEncrypted {
    return Intl.message(
      'All files encrypted!',
      name: 'allFilesEncrypted',
      desc: 'Success message after all files are encrypted',
      args: [],
    );
  }

  /// `Preparing...`
  String get preparing {
    return Intl.message(
      'Preparing...',
      name: 'preparing',
      desc: 'Status text while preparing import',
      args: [],
    );
  }

  /// `No files yet`
  String get noFilesYet {
    return Intl.message(
      'No files yet',
      name: 'noFilesYet',
      desc: 'Empty state title',
      args: [],
    );
  }

  /// `Tap + to import and encrypt your first file`
  String get tapToImport {
    return Intl.message(
      'Tap + to import and encrypt your first file',
      name: 'tapToImport',
      desc: 'Empty state subtitle',
      args: [],
    );
  }

  /// `Search files...`
  String get searchFiles {
    return Intl.message(
      'Search files...',
      name: 'searchFiles',
      desc: 'Search bar hint text',
      args: [],
    );
  }

  /// `Benchmark: Dart vs C (FFI)`
  String get benchmarkTitle {
    return Intl.message(
      'Benchmark: Dart vs C (FFI)',
      name: 'benchmarkTitle',
      desc: 'Benchmark screen app bar title',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: 'Undo action label',
      args: [],
    );
  }

  /// `"{fileName}" deleted`
  String fileDeleted(String fileName) {
    return Intl.message(
      '"$fileName" deleted',
      name: 'fileDeleted',
      desc: 'SnackBar message after file deletion',
      args: [fileName],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: 'Tags section label',
      args: [],
    );
  }

  /// `Import to folder`
  String get importToFolder {
    return Intl.message(
      'Import to folder',
      name: 'importToFolder',
      desc: 'Folder picker sheet title',
      args: [],
    );
  }

  /// `No folder`
  String get noFolder {
    return Intl.message(
      'No folder',
      name: 'noFolder',
      desc: 'Option to import file without assigning to a folder',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<GeneratedLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<GeneratedLocalization> load(Locale locale) =>
      GeneratedLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
