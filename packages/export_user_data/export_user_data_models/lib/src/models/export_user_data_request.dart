import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:export_user_data_models/export_user_data_models.dart';
import 'package:export_user_data_models/src/models/export_user_data_request_status.dart';
import 'package:filesize_ns/filesize_ns.dart';

class ExportUserDataRequest {
  final String id;
  final String userId;
  final DateTime requestTime;
  final DateTime? expiresOn;
  final String? downloadUrl;
  final int? totalBytes;
  final String? error;
  final ExportUserDataRequestStatus status;

  const ExportUserDataRequest._({
    required this.id,
    required this.userId,
    required this.requestTime,
    required this.expiresOn,
    required this.downloadUrl,
    required this.totalBytes,
    required this.status,
    required this.error,
  });

  factory ExportUserDataRequest.createForUserId(
      String requestId, String userId) {
    return ExportUserDataRequest._(
      id: requestId,
      userId: userId,
      requestTime: DateTime.now(),
      expiresOn: null,
      downloadUrl: null,
      totalBytes: null,
      status: ExportUserDataRequestStatus.loading,
      error: null,
    );
  }

  factory ExportUserDataRequest.fromData(
      String key, Map<String, dynamic> data) {
    try {
      return ExportUserDataRequest._(
        id: key,
        userId: data['userId'],
        requestTime: (data['requestTime'] as Timestamp).toDate(),
        expiresOn: data['expiresOn'] != null
            ? (data['expiresOn'] as Timestamp).toDate()
            : null,
        downloadUrl: data['downloadUrl'],
        totalBytes: data['totalBytes'],
        status: ExportUserDataRequestStatusConverter.fromData(data['status']),
        error: data['error'],
      );
    } catch (e) {
      throw Exception('ExportUserDataRequest Parsing Exception!');
    }
  }

  Map<String, dynamic> toData() {
    return {
      'userId': userId,
      'requestTime': Timestamp.fromDate(requestTime),
      'expiresOn': expiresOn != null ? Timestamp.fromDate(expiresOn!) : null,
      'downloadUrl': downloadUrl,
      'totalBytes': totalBytes,
      'status': ExportUserDataRequestStatusConverter.toData(status),
      'error': error,
    };
  }

  ExportUserDataRequestView toView() {
    return ExportUserDataRequestView(
      userId: userId,
      requestTime: requestTime,
      expiresOn: expiresOn,
      downloadUrl: downloadUrl,
      bytesSize: totalBytes != null ? filesize(totalBytes) : null,
      status: status,
      error: error,
    );
  }
}
