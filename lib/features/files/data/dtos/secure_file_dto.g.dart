// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_file_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecureFileDtoAdapter extends TypeAdapter<SecureFileDto> {
  @override
  final int typeId = 0;

  @override
  SecureFileDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecureFileDto(
      id: fields[0] as String,
      name: fields[1] as String,
      typeIndex: fields[2] as int,
      size: fields[3] as int,
      encryptedPath: fields[4] as String,
      thumbnailPath: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      tags: (fields[8] as List).cast<String>(),
      folderId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SecureFileDto obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.typeIndex)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.encryptedPath)
      ..writeByte(5)
      ..write(obj.thumbnailPath)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.folderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecureFileDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
