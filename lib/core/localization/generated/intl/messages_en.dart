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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("Secure App"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
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
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "Protected with OWASP standards"),
        "signInWithGoogle":
            MessageLookupByLibrary.simpleMessage("Sign in with Google")
      };
}
