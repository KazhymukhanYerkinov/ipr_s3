import 'package:flutter_test/flutter_test.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

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

    test('two users with same props should be equal (Equatable)', () {
      const user1 = UserEntity(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      const user2 = UserEntity(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user1, equals(user2));
    });

    test('two users with different uid should not be equal', () {
      const other = UserEntity(
        uid: '456',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user, isNot(equals(other)));
    });

    test('two users with different email should not be equal', () {
      const other = UserEntity(
        uid: '123',
        email: 'other@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user, isNot(equals(other)));
    });

    test('props should contain all fields in correct order', () {
      expect(user.props, [
        '123',
        'test@example.com',
        'Test User',
        'https://example.com/photo.jpg',
      ]);
    });

    test('props should contain null photoUrl', () {
      const userNoPhoto = UserEntity(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(userNoPhoto.props, ['123', 'test@example.com', 'Test User', null]);
    });
  });
}
