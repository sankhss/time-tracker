import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  final Auth auth;
  final StreamController<bool> _isLoadingController = StreamController();

  SignInBloc(this.auth);

  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    } 
  }
  Future<User> signInAnonymously() async => await signIn(auth.signInAnonymously); 
  Future<User> signInWithGoogle() async => await signIn(auth.signInWithGoogle); 
  Future<User> signInWithFacebook() async => await signIn(auth.signInWithFacebook); 

  void dispose() { 
    _isLoadingController.close();
  }
}