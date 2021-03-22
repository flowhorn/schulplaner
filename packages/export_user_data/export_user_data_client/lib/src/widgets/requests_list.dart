import 'package:bloc/bloc_provider.dart';
import 'package:export_user_data_models/export_user_data_models.dart';
import 'package:flutter/material.dart';
import '../bloc/export_user_data_client_bloc.dart';
import 'request_card.dart';

class RequestsList extends StatelessWidget {
  const RequestsList();
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ExportUserDataClientBloc>(context);
    return StreamBuilder<List<ExportUserDataRequestView>>(
      stream: bloc.exportUserDataRequests,
      initialData: bloc.exportUserDataRequestInitialData,
      builder: (context, snapshot) {
        final requests = snapshot.data;
        if (requests == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Meine Anfragen:'),
            ),
            for (final requestView in requests)
              RequestCard(
                requestView: requestView,
              ),
          ],
        );
      },
    );
  }
}
