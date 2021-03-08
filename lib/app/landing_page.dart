import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/home_page.dart';
import 'package:time_tracker/app/home/job/jobs_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<Auth>(context, listen: false).onAuthStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return Provider<Database>(
              create: (ctx) => FirestoreDatabase(user.uid),
              child: HomePage(),
            );
          }
          return SignInPage.create(context);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
