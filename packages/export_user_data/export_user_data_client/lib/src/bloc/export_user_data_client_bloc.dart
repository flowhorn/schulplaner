import 'package:bloc/bloc_base.dart';
import 'package:export_user_data_client/src/services/download_service.dart';
import 'package:export_user_data_client/src/services/export_user_data_service.dart';
import 'package:export_user_data_models/export_user_data_models.dart';
import 'package:rxdart/subjects.dart';

class ExportUserDataClientBloc extends BlocBase {
  final _exportUserDataSubject =
      BehaviorSubject<List<ExportUserDataRequestView>>.seeded(
          const <ExportUserDataRequestView>[]);

  final DownloadService downloadService;
  final ExportUserDataService exportUserDataService;

  ExportUserDataClientBloc({
    required this.downloadService,
    required this.exportUserDataService,
  }) {
    _exportUserDataSubject
        .addStream(exportUserDataService.streamExportUserDataRequests());
  }

  List<ExportUserDataRequestView> get exportUserDataRequestInitialData =>
      _exportUserDataSubject.value;

  Stream<List<ExportUserDataRequestView>> get exportUserDataRequests =>
      _exportUserDataSubject;

  Future<bool> requestExportUserData() async {
    return exportUserDataService.sendExportUserDataRequest();
  }

  Future<bool> downloadFromUrl(String url) {
    return downloadService.downloadFromUrl(url);
  }

  @override
  void dispose() {}
}
