import 'package:time_tracker/app/sign_in/email/validators.dart';

enum FormType {
  SIGN_IN,
  SIGN_UP,
}

class EmailSignInModel with Validators {
  final String email;
  final String password;
  final String confirmPassword;
  final FormType formType;
  final bool submitted;
  final bool isLoading;

  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formType = FormType.SIGN_IN,
    this.submitted = false,
    this.isLoading = false,
  });

  EmailSignInModel copyWith({
    String email,
    String password,
    String confirmPassword,
    FormType formType,
    bool submitted,
    bool isLoading,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formType: formType ?? this.formType,
      submitted: submitted ?? this.submitted,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isSignInFormType=> formType == FormType.SIGN_IN;
  bool get isSignUpFormType=> formType == FormType.SIGN_UP;

  String get emailErrorText =>
      !isValidEmail(email) && submitted ? invalidEmailMessage : null;
  String get passwordErrorText =>
      !isValidPassword(password) && submitted ? invalidPasswordMessage : null;
  String get confirmPasswordErrorText =>
      !passwordsMatch(password, confirmPassword) && submitted
          ? passwordsDontMatchMessage
          : null;

  String get formTypeName =>
      formType == FormType.SIGN_IN ? 'Sign in' : 'Create an account';

  String get formTypeText => formType == FormType.SIGN_IN
      ? 'Need an account? Register.'
      : 'Have an account? Sign in.';

  bool get canSubmit {
    bool isEmailAndPassordValidNotEmpty =
        email.isNotEmpty && password.isNotEmpty && !isLoading;
    return formType == FormType.SIGN_IN
        ? isEmailAndPassordValidNotEmpty
        : isEmailAndPassordValidNotEmpty && confirmPassword.isNotEmpty;
  }

  bool get isValid {
    bool isEmailAndPassordValid =
        isValidEmail(email) && isValidPassword(password);
    return formType == FormType.SIGN_IN
        ? isEmailAndPassordValid
        : isEmailAndPassordValid && passwordsMatch(password, confirmPassword);
  }
}
