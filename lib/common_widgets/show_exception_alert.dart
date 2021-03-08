import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/show_platform_alert_dialog.dart';

Future<void> showExceptionAlert(
  BuildContext context, {
  String title = 'Operation failed',
  Exception exception,
}) {
  return showPlatformAlertDialog(
    context,
    title: title,
    content: _message(exception),
    defaultActionText: 'Close',
  );
}

String _message(Exception e) {
  if (e is FirebaseException) {
    return e.message;
  }
  return e.toString();
}
