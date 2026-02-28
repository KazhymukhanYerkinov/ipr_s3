import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:ipr_s3/features/auth/domain/models/user.dart';

class UserDto implements UserEntity {
  @override
  final String uid;

  @override
  final String email;

  @override
  final String displayName;

  @override
  final String? photoUrl;

  const UserDto({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
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
