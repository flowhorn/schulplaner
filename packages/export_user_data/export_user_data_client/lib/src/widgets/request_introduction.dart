import 'package:export_user_data_client/src/widgets/request_export_button.dart';
import 'package:flutter/material.dart';

class RequestIntroduction extends StatelessWidget {
  const RequestIntroduction();
  @override
  Widget build(BuildContext context) {
    return Column(
      children:  [
        ListTile(
          title: Text(
            'Das Abrufen der Daten kann einige Minuten dauern.'
            'Wir stellen alle Daten übersichtlich zusammen, sodass ihr sie einfach einsehen könnt.'
            '7 Tage lang stehen dir diese zum Download verfügbar.',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RequestExportButton(),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
