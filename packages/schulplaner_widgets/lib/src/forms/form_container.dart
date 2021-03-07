//@dart=2.11
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({@required this.child, this.padding});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: getHighlightedColor(context),
      child: padding == null
          ? child
          : Padding(
              padding: padding,
              child: child,
            ),
    );
  }
}
