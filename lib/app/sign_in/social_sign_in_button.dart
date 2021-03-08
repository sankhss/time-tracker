import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  final String title;
  final Image image;
  final Color color;
  final Color textColor;
  final Function onPressed;

  SocialSignInButton({
    @required this.title,
    this.image,
    this.color,
    this.textColor,
    this.onPressed,
  })  : assert(title != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (image != null) image,
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.0,
                  color: textColor,
                ),
              ),
              if (image != null) Opacity(opacity: 0.0, child: image),
            ],
          ),
          color: color,
          height: 50.0,
          onPressed: onPressed,
        );
}
