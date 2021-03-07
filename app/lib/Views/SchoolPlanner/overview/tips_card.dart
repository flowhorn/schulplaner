import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class TipsCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Widget content;
  final List<Widget>? bottom;

  const TipsCard({
    Key? key,
    required this.iconData,
    required this.title,
    required this.content,
    this.bottom,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 12.0, bottom: 12.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.grey),
                      ),),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: content,
            ),
            if (bottom != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: bottom!,
                    mainAxisAlignment: MainAxisAlignment.start),
              ),
            FormSpace(4.0),
          ],
        ),
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: getDividerColor(context),
            ),),
      ),
    );
  }
}
