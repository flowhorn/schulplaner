import 'package:export_user_data_models/export_user_data_models.dart';

abstract class ExportUserDataService {
  Stream<List<ExportUserDataRequestView>> streamExportUserDataRequests();

  Future<bool> sendExportUserDataRequest();
}
