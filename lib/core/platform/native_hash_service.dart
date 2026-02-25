import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

// ─── C function signatures (NativeFunction types) ────────────────────────────
typedef NativeCrc32 = Uint32 Function(Pointer<Uint8>, Int32);
typedef NativeDjb2 = Uint32 Function(Pointer<Utf8>);
typedef NativeCountBytes = Int32 Function(Pointer<Uint8>, Int32, Uint8);

// ─── Dart function signatures ────────────────────────────────────────────────
typedef DartCrc32 = int Function(Pointer<Uint8>, int);
typedef DartDjb2 = int Function(Pointer<Utf8>);
typedef DartCountBytes = int Function(Pointer<Uint8>, int, int);

/// FFI wrapper for native C hash functions (hash_utils.c).
///
/// Loads `libhash_utils.so` on Android via [DynamicLibrary.open],
/// or uses [DynamicLibrary.process] on iOS (statically linked).
///
/// Provides:
/// - [crc32] — file integrity verification after encryption
/// - [djb2Hash] — fast string hashing for deduplication
/// - [countBytes] — byte frequency analysis for entropy checks
///
/// Memory management: each method allocates native memory via [malloc],
/// copies Dart data, calls the C function, and frees memory in a
/// `try/finally` block to prevent leaks.
@lazySingleton
class NativeHashService {
  final _logger = SecureLogger();

  late final DartCrc32 _crc32;
  late final DartDjb2 _djb2Hash;
  late final DartCountBytes _countBytes;

  NativeHashService() {
    final DynamicLibrary lib;

    if (Platform.isAndroid) {
      lib = DynamicLibrary.open('libhash_utils.so');
    } else if (Platform.isIOS) {
      lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError(
        'NativeHashService is only supported on Android and iOS',
      );
    }

    _crc32 = lib.lookupFunction<NativeCrc32, DartCrc32>('native_crc32');
    _djb2Hash = lib.lookupFunction<NativeDjb2, DartDjb2>('native_djb2_hash');
    _countBytes = lib.lookupFunction<NativeCountBytes, DartCountBytes>(
      'native_count_bytes',
    );

    _logger.info('Native hash library loaded successfully');
  }

  /// Computes CRC32 checksum of [data].
  /// Used to verify file integrity after encryption/before decryption.
  int crc32(Uint8List data) {
    final pointer = malloc<Uint8>(data.length);
    try {
      pointer.asTypedList(data.length).setAll(0, data);
      return _crc32(pointer, data.length);
    } finally {
      malloc.free(pointer);
    }
  }

  /// Computes DJB2 hash of [input] string.
  /// Used for fast file name deduplication on import.
  int djb2Hash(String input) {
    final pointer = input.toNativeUtf8();
    try {
      return _djb2Hash(pointer);
    } finally {
      malloc.free(pointer);
    }
  }

  /// Counts occurrences of [target] byte in [data].
  /// Used for entropy analysis of encrypted files.
  int countBytes(Uint8List data, int target) {
    final pointer = malloc<Uint8>(data.length);
    try {
      pointer.asTypedList(data.length).setAll(0, data);
      return _countBytes(pointer, data.length, target);
    } finally {
      malloc.free(pointer);
    }
  }
}
