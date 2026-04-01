import 'dart:typed_data';

abstract class NativeHashBehavior {
  int crc32(Uint8List data);

  Future<int> crc32InIsolate(Uint8List data);
}
