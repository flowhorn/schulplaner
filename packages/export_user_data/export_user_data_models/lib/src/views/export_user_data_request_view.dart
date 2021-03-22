import 'package:export_user_data_models/src/models/export_user_data_request_status.dart';

class ExportUserDataRequestView {
  final String userId;
  final DateTime requestTime;
  final DateTime? expiresOn;
  final String? downloadUrl;
  final String? bytesSize;
  final String? error;
  final ExportUserDataRequestStatus status;

  const ExportUserDataRequestView({
    required this.userId,
    required this.downloadUrl,
    required this.requestTime,
    required this.expiresOn,
    required this.bytesSize,
    required this.error,
    required this.status,
  });
}
