//@dart=2.11
import 'package:flutter/material.dart';

class AuthentificationLoginTile extends StatelessWidget {
  const AuthentificationLoginTile(
      {Key key, this.iconData, this.color, this.title, this.onTap})
      : super(key: key);
  final IconData iconData;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                iconData,
                color: color,
                size: 28.0,
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
