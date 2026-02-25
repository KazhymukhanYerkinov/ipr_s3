import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:ipr_s3/features/auth/data/dtos/user_dto.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

class UserMapper {
  static UserEntity fromDto(UserDto dto) {
    return UserEntity(
      uid: dto.uid,
      email: dto.email,
      displayName: dto.displayName,
      photoUrl: dto.photoUrl,
    );
  }

  static UserDto toDto(UserEntity entity) {
    return UserDto(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
    );
  }

  static UserEntity fromFirebaseUser(firebase.User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
    );
  }
}
