import 'package:flutter_test/flutter_test.dart';
import 'package:ipr_s3/core/error/failures.dart';

void main() {
  group('AuthFailure', () {
    test('should create with message', () {
      const failure = AuthFailure(message: 'auth error');
      expect(failure.message, 'auth error');
    });

    test('two failures with same message should be equal', () {
      const f1 = AuthFailure(message: 'error');
      const f2 = AuthFailure(message: 'error');
      expect(f1, equals(f2));
    });

    test('two failures with different messages should not be equal', () {
      const f1 = AuthFailure(message: 'error 1');
      const f2 = AuthFailure(message: 'error 2');
      expect(f1, isNot(equals(f2)));
    });

    test('props should contain message', () {
      const failure = AuthFailure(message: 'test');
      expect(failure.props, ['test']);
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

    test('two failures with same message should be equal', () {
      const f1 = CacheFailure(message: 'error');
      const f2 = CacheFailure(message: 'error');
      expect(f1, equals(f2));
    });

    test('should be a subtype of Failure', () {
      const failure = CacheFailure(message: 'test');
      expect(failure, isA<Failure>());
    });

    test('AuthFailure and CacheFailure with same message should not be equal', () {
      const auth = AuthFailure(message: 'error');
      const cache = CacheFailure(message: 'error');
      expect(auth, isNot(equals(cache)));
    });
  });
}
