import 'package:flutter_test/flutter_test.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

/// Smoke-тест: проверяет, что основные модели проекта корректно создаются
void main() {
  test('App smoke test — core models instantiate correctly', () {
    const user = UserEntity(
      uid: 'smoke-test-uid',
      email: 'smoke@test.com',
      displayName: 'Smoke Test',
    );

    expect(user.uid, 'smoke-test-uid');
    expect(user.email, 'smoke@test.com');
    expect(user.displayName, 'Smoke Test');
    expect(user.photoUrl, isNull);
  });
}
