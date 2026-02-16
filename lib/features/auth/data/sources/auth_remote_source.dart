import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/auth/data/dtos/user_dto.dart';

abstract class AuthRemoteSource {
  Future<void> signOut();
  UserDto? getCurrentUser();
  Future<UserDto> signInWithGoogle();
}

@LazySingleton(as: AuthRemoteSource)
class AuthRemoteSourceImpl implements AuthRemoteSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<UserDto> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In cancelled by user');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) {
      throw Exception('Firebase sign-in returned null user');
    }

    return UserDto.fromFirebaseUser(user);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  UserDto? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserDto.fromFirebaseUser(user);
  }
}
