import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/email/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInForm extends StatefulWidget {
  final EmailSignInBloc bloc;

  EmailSignInForm({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInForm(bloc: bloc),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlert(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggle() {
    widget.bloc.toggleFormType();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final model = snapshot.data;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocus,
                    onChanged: (email) => widget.bloc.updateWith(email: email),
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'test@email.com',
                      errorText: model.emailErrorText,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: model.isSignInFormType
                        ? TextInputAction.done
                        : TextInputAction.next,
                    focusNode: _passwordFocus,
                    onChanged: (password) =>
                        widget.bloc.updateWith(password: password),
                    onEditingComplete: model.isSignInFormType
                        ? _submit
                        : () => FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocus),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: model.passwordErrorText,
                    ),
                  ),
                  if (model.isSignUpFormType)
                    ..._buildConfirmPasswordField(model),
                  SizedBox(height: 8.0),
                  FormSubmitButton(
                    label: model.formTypeName,
                    onPressed: model.canSubmit ? _submit : null,
                  ),
                  SizedBox(height: 8.0),
                  FlatButton(
                    child: Text(model.formTypeText),
                    onPressed: _toggle,
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<Widget> _buildConfirmPasswordField(EmailSignInModel model) {
    return [
      SizedBox(height: 8.0),
      TextField(
        controller: _confirmPasswordController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        focusNode: _confirmPasswordFocus,
        onChanged: (confirmPassword) =>
            widget.bloc.updateWith(confirmPassword: confirmPassword),
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          errorText: model.confirmPasswordErrorText,
        ),
      ),
    ];
  }
}
