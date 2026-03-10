import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/native_hash_behavior.dart';

typedef NativeCrc32 = Uint32 Function(Pointer<Uint8>, Int32);
typedef DartCrc32 = int Function(Pointer<Uint8>, int);

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
}
