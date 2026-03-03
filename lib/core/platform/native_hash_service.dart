import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/native_hash_behavior.dart';

typedef NativeCrc32 = Uint32 Function(Pointer<Uint8>, Int32);
typedef NativeDjb2 = Uint32 Function(Pointer<Utf8>);
typedef NativeCountBytes = Int32 Function(Pointer<Uint8>, Int32, Uint8);

typedef DartCrc32 = int Function(Pointer<Uint8>, int);
typedef DartDjb2 = int Function(Pointer<Utf8>);
typedef DartCountBytes = int Function(Pointer<Uint8>, int, int);

@LazySingleton(as: NativeHashBehavior)
class NativeHashService implements NativeHashBehavior {
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
  int djb2Hash(String input) {
    final pointer = input.toNativeUtf8();
    try {
      return _djb2Hash(pointer);
    } finally {
      malloc.free(pointer);
    }
  }

  @override
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
