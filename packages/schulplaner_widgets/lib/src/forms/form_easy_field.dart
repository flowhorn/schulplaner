import 'package:flutter/material.dart';
import 'form_divider.dart';

class FormEasyField extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double spaceBottom;
  final double spaceTop;
  const FormEasyField(
      {@required this.child,
      this.padding,
      this.spaceBottom = 0.0,
      this.spaceTop = 0.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: spaceTop,
        ),
        FormDivider(),
        padding == null
            ? child
            : Padding(
                padding: padding,
                child: child,
              ),
        FormDivider(),
        SizedBox(
          height: spaceBottom,
        ),
      ],
    );
  }
}
