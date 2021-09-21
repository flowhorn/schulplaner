import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class EmptyListState extends StatelessWidget {
  const EmptyListState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 64,
          backgroundColor: getPrimaryColor(context),
          child: Icon(
            Icons.lightbulb_outline,
            size: 96,
            color: getBackgroundColor(context),
          ),
        ),
        SizedBox(height: 6),
        ListTile(
          title: Text(
            BothLangString(
                    de: 'Noch keine Einträge...', en: 'No entries yet...')
                .getText(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
