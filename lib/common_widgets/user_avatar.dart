import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String photoUrl;
  final double borderRadius;

  const UserAvatar({Key key, this.photoUrl, @required this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black54,
          width: 1.0,
        ),
      ),
      child: CircleAvatar(
        radius: borderRadius,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null ? Icon(Icons.camera_alt) : null,
      ),
    );
  }
}