import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  final String title;
  final Color color;
  final Color textColor;
  final Function onPressed;

  SignInButton({
    @required this.title,
    this.color,
    this.textColor,
    this.onPressed,
  })  : assert(title != null),
        super(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              color: textColor,
            ),
          ),
          color: color,
          height: 50.0,
          onPressed: onPressed,
        );
}
