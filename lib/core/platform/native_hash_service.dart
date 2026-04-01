import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/native_hash_behavior.dart';

typedef NativeCrc32 = Uint32 Function(Pointer<Uint8>, Int32);
typedef DartCrc32 = int Function(Pointer<Uint8>, int);

/// Runs native CRC32 inside an isolate via [compute].
///
/// Each isolate has its own heap, so we open [DynamicLibrary] and look up
/// the C function from scratch. The library open cost is negligible compared
/// to the actual hash computation on multi-MB inputs.
int _nativeCrc32InIsolate(Uint8List data) {
  final DynamicLibrary lib;
  if (Platform.isAndroid) {
    lib = DynamicLibrary.open('libhash_utils.so');
  } else if (Platform.isIOS) {
    lib = DynamicLibrary.process();
  } else {
    throw UnsupportedError('Unsupported platform for FFI');
  }

  final nativeFn = lib.lookupFunction<NativeCrc32, DartCrc32>('native_crc32');

  final pointer = malloc<Uint8>(data.length);
  try {
    pointer.asTypedList(data.length).setAll(0, data);
    return nativeFn(pointer, data.length);
  } finally {
    malloc.free(pointer);
  }
}

/// Provides CRC32 hashing via a native C library loaded through dart:ffi.
///
/// On Android the shared library `libhash_utils.so` is loaded at runtime.
/// On iOS the C code is statically linked into the binary and accessed
/// via [DynamicLibrary.process].
@LazySingleton(as: NativeHashBehavior)
class NativeHashService implements NativeHashBehavior {
  late final DartCrc32 _crc32;

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
  }

  @override
  int crc32(Uint8List data) {
    final pointer = malloc<Uint8>(data.length);
    try {
      pointer.asTypedList(data.length).setAll(0, data);
      return _crc32(pointer, data.length);
    } finally {
      malloc.free(pointer);
    }
  }

  @override
  Future<int> crc32InIsolate(Uint8List data) {
    return compute(_nativeCrc32InIsolate, data);
  }
}
