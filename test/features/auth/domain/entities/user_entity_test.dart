import 'package:flutter_test/flutter_test.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

void main() {
  group('UserEntity', () {
    const user = UserEntity(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
    );

    test('should create with correct properties', () {
      expect(user.uid, '123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
    });

    test('should support null photoUrl', () {
      const userNoPhoto = UserEntity(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(userNoPhoto.photoUrl, isNull);
    });
  });
}
