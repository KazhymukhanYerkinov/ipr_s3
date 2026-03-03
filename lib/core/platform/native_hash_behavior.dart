import 'dart:typed_data';

abstract class NativeHashBehavior {
  int crc32(Uint8List data);
  int djb2Hash(String input);
  int countBytes(Uint8List data, int target);
}
