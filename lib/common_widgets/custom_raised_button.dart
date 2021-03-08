import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final Function onPressed;

  const CustomRaisedButton({
    this.child,
    @required this.onPressed,
    this.borderRadius = 2.0,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        onPressed: onPressed,
      ),
    );
  }
}
