import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      height: 144,
      width: double.infinity,
      child: Text('Footer'),
    );
  }
}
