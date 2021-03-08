import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_platform_alert_dialog.dart';
import 'package:time_tracker/common_widgets/user_avatar.dart';
import 'package:time_tracker/services/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await Provider.of<Auth>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showPlatformAlertDialog(
      context,
      title: 'Confirmation',
      content: 'Are you sure that you want to logout from the application?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    );
    if (shouldSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
      body: Container(),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        UserAvatar(
          photoUrl: user.photoURL,
          borderRadius: 50.0,
        ),
        SizedBox(height: 8.0),
        Text(
          user.displayName,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
