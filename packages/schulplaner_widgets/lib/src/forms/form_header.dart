import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String title;
  final Color color;
  const FormHeader(this.title, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: color,
          ),
        ),
      ),
    );
  }
}

class FormHeader2 extends StatelessWidget {
  final String title;
  final Color color;
  const FormHeader2(this.title, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.0,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Text(
          (title ?? '').toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14.0,
            color: color,
          ),
        ),
      ),
    );
  }
}

class FormHeaderAdvanced extends StatelessWidget {
  final String title;
  final Widget trailing;
  FormHeaderAdvanced(this.title, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            ),
          ),
          if (trailing != null)
            Positioned(
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
              child: trailing,
            ),
        ],
      ),
    );
  }
}
