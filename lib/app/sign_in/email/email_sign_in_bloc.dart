import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:time_tracker/app/sign_in/email/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  final Auth auth;
  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  EmailSignInBloc(this.auth);

  EmailSignInModel get _model => _modelSubject.value;

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;

  void updateWith({
    String email,
    String password,
    String confirmPassword,
    FormType formType,
    bool submitted,
    bool isLoading,
  }) {
    _modelSubject.value = _model.copyWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      formType: formType,
      submitted: submitted,
      isLoading: isLoading,
    );
  }

  Future<void> submit() async {
    updateWith(submitted: true);
    try {
      if (_model.isValid) {
        updateWith(isLoading: true);
        if (_model.isSignInFormType) {
          await auth.signInWithEmailAndPassword(_model.email, _model.password);
        } else {
          await auth.createUserWithEmailAndPassword(
              _model.email, _model.password);
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      updateWith(isLoading: false);
      print(e);
      rethrow;
    }
  }

  void toggleFormType() {
    updateWith(
      submitted: false,
      formType: _model.isSignInFormType
          ? FormType.SIGN_UP
          : FormType.SIGN_IN,
    );
  }

  void dispose() {
    _modelSubject.close();
  }
}
