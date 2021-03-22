import 'package:bloc/bloc_provider.dart';
import 'package:export_user_data_client/export_user_data_client.dart';
import 'package:export_user_data_models/export_user_data_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final ExportUserDataRequestView requestView;

  const RequestCard({
    Key? key,
    required this.requestView,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Anfrage von ${DateFormat.yMMMMEEEEd().format(requestView.requestTime)}, ${DateFormat.Hms().format(requestView.requestTime)}',
              ),
            ),
            ListTile(
              title: _Status(
                status: requestView.status,
                error: requestView.error,
                bytesSize: requestView.bytesSize,
              ),
              trailing: _DownloadButton(
                downloadUrl: requestView.downloadUrl,
              ),
              subtitle: requestView.expiresOn != null
                  ? _ExpiresOn(expiresOn: requestView.expiresOn!)
                  : null,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final String? downloadUrl;

  const _DownloadButton({
    Key? key,
    required this.downloadUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(Icons.download_outlined),
      label: Text('Downloaden'),
      onPressed: downloadUrl != null
          ? () {
              final bloc = BlocProvider.of<ExportUserDataClientBloc>(context);
              bloc.downloadFromUrl(downloadUrl!);
            }
          : null,
    );
  }
}

class _Status extends StatelessWidget {
  final ExportUserDataRequestStatus status;
  final String? bytesSize;
  final String? error;

  const _Status({
    Key? key,
    required this.status,
    this.bytesSize,
    this.error,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ExportUserDataRequestStatus.loading:
        {
          return Text(
            'Status: In Bearbeitung',
            style: TextStyle(
              color: Colors.orangeAccent,
            ),
          );
        }
      case ExportUserDataRequestStatus.successful:
        {
          return Text(
            'Status: Download verfügbar ($bytesSize)',
            style: TextStyle(
              color: Colors.greenAccent,
            ),
          );
        }
      case ExportUserDataRequestStatus.error:
        {
          return Text(
            'Status: Fehlgeschlagen ($error)',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          );
        }
    }
  }
}

class _ExpiresOn extends StatelessWidget {
  final DateTime expiresOn;

  const _ExpiresOn({Key? key, required this.expiresOn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text('Verfügbar bis ${expiresOn.toIso8601String()}');
  }
}
