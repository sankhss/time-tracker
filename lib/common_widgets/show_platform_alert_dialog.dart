import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<bool> showPlatformAlertDialog(
  BuildContext context, {
  @required String title,
  @required String content,
  @required String defaultActionText,
  String cancelActionText,
}) {
  return Platform.isIOS
      ? _showIOSAlert(
          context,
          title: title,
          content: content,
          defaultActionText: defaultActionText,
          cancelActionText: cancelActionText,
        )
      : _showAndroidAlert(
          context,
          title: title,
          content: content,
          defaultActionText: defaultActionText,
          cancelActionText: cancelActionText,
        );
}

Future<bool> _showAndroidAlert(
  BuildContext context, {
  @required String title,
  @required String content,
  @required String defaultActionText,
  String cancelActionText,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
        FlatButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelActionText),
        ),
        FlatButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

Future<bool> _showIOSAlert(
  BuildContext context, {
  @required String title,
  @required String content,
  @required String defaultActionText,
  String cancelActionText,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
        CupertinoDialogAction(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelActionText),
          isDefaultAction: true,
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
