import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:export_user_data_client/src/services/export_user_data_service.dart';
import 'package:export_user_data_models/export_user_data_models.dart';
import 'package:export_user_data_models/src/views/export_user_data_request_view.dart';

class FirestoreExportUserDataService implements ExportUserDataService {
  final FirebaseFirestore _firestore;
  final String userId;
  const FirestoreExportUserDataService({
    required FirebaseFirestore firestore,
    required this.userId,
  }) : _firestore = firestore;

  CollectionReference get _exportUserDataRequestsCollection =>
      _firestore.collection('ExportUserDataRequests');

  String get generateNewId => _exportUserDataRequestsCollection.doc().id;

  DocumentReference exportUserDataRequestsDocument(String id) =>
      _exportUserDataRequestsCollection.doc(id);
  @override
  Future<bool> sendExportUserDataRequest() async {
    final requestId = generateNewId;
    final requestData =
        ExportUserDataRequest.createForUserId(requestId, userId);
    exportUserDataRequestsDocument(requestId).set(requestData.toData());
    return true;
  }

  @override
  Stream<List<ExportUserDataRequestView>> streamExportUserDataRequests() {
    final snapshots = _exportUserDataRequestsCollection
        .where('userId', isEqualTo: userId)
        .snapshots();
    return snapshots.map(
      (querySnap) => querySnap.docs
          .map(
            (docSnap) =>
                ExportUserDataRequest.fromData(docSnap.id, docSnap.data()!)
                    .toView(),
          )
          .toList()
            ..sort(
              (item1, item2) => item2.requestTime.compareTo(item1.requestTime),
            ),
    );
  }
}
