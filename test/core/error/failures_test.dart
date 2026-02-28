import 'package:flutter_test/flutter_test.dart';
import 'package:ipr_s3/core/error/failures.dart';

void main() {
  group('AuthFailure', () {
    test('should create with message', () {
      const failure = AuthFailure(message: 'auth error');
      expect(failure.message, 'auth error');
    });

    test('should be a subtype of Failure', () {
      const failure = AuthFailure(message: 'test');
      expect(failure, isA<Failure>());
    });
  });

  group('CacheFailure', () {
    test('should create with message', () {
      const failure = CacheFailure(message: 'cache error');
      expect(failure.message, 'cache error');
    });

    test('should be a subtype of Failure', () {
      const failure = CacheFailure(message: 'test');
      expect(failure, isA<Failure>());
    });
  });

  group('FileFailure', () {
    test('should create with message', () {
      const failure = FileFailure(message: 'file error');
      expect(failure.message, 'file error');
    });

    test('should be a subtype of Failure', () {
      const failure = FileFailure(message: 'test');
      expect(failure, isA<Failure>());
    });
  });

  group('EncryptionFailure', () {
    test('should create with message', () {
      const failure = EncryptionFailure(message: 'encryption error');
      expect(failure.message, 'encryption error');
    });

    test('should be a subtype of Failure', () {
      const failure = EncryptionFailure(message: 'test');
      expect(failure, isA<Failure>());
    });
  });
}
