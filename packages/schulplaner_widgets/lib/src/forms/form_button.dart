import 'package:flutter/material.dart';

import '../common/r_button.dart';

class FormButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onTap;
  const FormButton(this.text, this.onTap, {this.iconData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: Center(
        child: RButton(text: text ?? "-", onTap: onTap, iconData: iconData),
      ),
    );
  }
}
