import 'package:flutter/material.dart';

class EmptyContentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nothing here',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 32.0,
            ),
          ),
          Text(
            'Add a new item to get started',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
