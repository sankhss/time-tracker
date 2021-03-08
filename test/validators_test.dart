import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/app/sign_in/email/validators.dart';

void main() {
  final validators = Validators();
  group('email', () {
    test('valid email', () {
      expect(validators.isValidEmail('email@domain.com'), true);
    });
    test('not valid email', () {
      expect(validators.isValidEmail('email@domain'), false);
    });
    test('empty email', () {
      expect(validators.isValidEmail(''), false);
    });
    test('null email', () {
      expect(validators.isValidEmail(null), false);
    });
  });

  group('password', () {
    test('valid password', () {
      expect(validators.isValidPassword('231239239'), true);
    });
    test('not valid password', () {
      expect(validators.isValidPassword('1234'), false);
    });
    test('empty password', () {
      expect(validators.isValidPassword(''), false);
    });
    test('null password', () {
      expect(validators.isValidPassword(null), false);
    });
    test('passwords match', () {
      expect(validators.passwordsMatch('123456', '123456'), true);
    });
    test('passwords do not match', () {
      expect(validators.passwordsMatch('123456', '654321'), false);
    });

    test('null match', () {
      expect(validators.passwordsMatch(null, null), true);
    });
  });
}
