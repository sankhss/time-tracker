import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email/email_sign_in_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  const SignInPage({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
    );
  }

  Future<void> _signInAnoninously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } catch (e) {
      _showSignInError(context, e);
    } 
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } catch (e) {
      _showSignInError(context, e);
    } 
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } catch (e) {
      _showSignInError(context, e);
    } 
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => EmailSignInPage(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception e) {
    if (e is FirebaseException && e.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlert(
      context,
      title: 'Sign in failed',
      exception: e,
    );
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48.0),
          if (!isLoading) ..._buildSignInButtons(context),
          if (isLoading) _buildLoadingFeedback(),
        ],
      ),
    );
  }

  Widget _buildLoadingFeedback() {
    return Center(child: CircularProgressIndicator());
  }

  List<Widget> _buildSignInButtons(BuildContext context) {
    return [
      SocialSignInButton(
        title: 'Login with Google',
        image: Image.asset('images/google-logo.png'),
        color: Colors.white,
        textColor: Colors.black87,
        onPressed: () => _signInWithGoogle(context),
      ),
      SizedBox(height: 8.0),
      SocialSignInButton(
        title: 'Login with Facebook',
        image: Image.asset('images/facebook-logo.png'),
        color: Color(0xFF334D92),
        textColor: Colors.white,
        onPressed: () => _signInWithFacebook(context),
      ),
      SizedBox(height: 8.0),
      SignInButton(
        title: 'Login with Email',
        color: Colors.teal[700],
        textColor: Colors.white,
        onPressed: () => _signInWithEmail(context),
      ),
      SizedBox(height: 8.0),
      Text(
        'or',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8.0),
      SignInButton(
        title: 'Go Anonimously',
        color: Colors.lime[300],
        textColor: Colors.black87,
        onPressed: () => _signInAnoninously(context),
      ),
    ];
  }
}
