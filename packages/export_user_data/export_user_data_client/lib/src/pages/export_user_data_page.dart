import 'package:export_user_data_client/src/widgets/request_introduction.dart';
import 'package:export_user_data_client/src/widgets/requests_list.dart';
import 'package:flutter/material.dart';

class ExportUserDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daten abrufen'),
      ),
      body: Column(
        children: [
          RequestIntroduction(),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          Expanded(
            child: RequestsList(),
          )
        ],
      ),
    );
  }
}
