class Validators {
  static const EMAIL_REGEX = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  
  bool isValidEmail(String value) {
    return value !=null && value.isNotEmpty && RegExp(EMAIL_REGEX).hasMatch(value);
  }
  String get invalidEmailMessage => 'Please enter a valid email address.';

  bool isValidPassword(String value) {
    return value !=null && value.isNotEmpty && value.length >= 5;
  }
  String get invalidPasswordMessage => 'Password must be at least 6 characters.';

  bool passwordsMatch(String password, String another) {
    return password == another;
  }
  String get passwordsDontMatchMessage => 'Password confirmation does not match.';

}
