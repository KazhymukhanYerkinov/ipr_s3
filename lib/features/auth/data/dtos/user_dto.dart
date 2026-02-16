import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

class UserDto extends UserEntity {
  const UserDto({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoUrl,
  });

  factory UserDto.fromFirebaseUser(firebase.User user) {
    return UserDto(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
    );
  }
}
