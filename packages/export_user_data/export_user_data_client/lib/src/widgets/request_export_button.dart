import 'package:bloc/bloc_provider.dart';
import 'package:export_user_data_client/export_user_data_client.dart';
import 'package:export_user_data_client/src/common/show_progress_sheet.dart';
import 'package:flutter/material.dart';

class RequestExportButton extends StatelessWidget {
  const RequestExportButton();
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ExportUserDataClientBloc>(context);
    return FloatingActionButton.extended(
      label: Text('Daten anfragen'),
      onPressed: () {
        showProgressSheet(
          context: context,
          future: bloc.requestExportUserData(),
        );
      },
    );
  }
}
