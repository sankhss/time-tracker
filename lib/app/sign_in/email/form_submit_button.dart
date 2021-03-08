import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  final String label;
  final Function onPressed;

  FormSubmitButton({
    @required this.label,
    @required this.onPressed,
  }) : super(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          height: 44.0,
          borderRadius: 4.0,
          color: Colors.indigo,
          onPressed: onPressed,
        );
}
