import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:cloud_functions/cloud_functions.dart';
//CODETYPE 0 = COURSE, 1 = CLASS

class PublicCode {
  String publiccode;
  int codetype;
  String referedid;
  String link;
  PublicCode({this.publiccode, this.codetype, this.referedid, this.link});

  PublicCode.fromData(Map<String, dynamic> data) {
    publiccode = data['publiccode'];
    codetype = data['codetype'];
    referedid = data['referredid'];
    link = data['link'];
  }

  Map<String, dynamic> toJson() {
    return {
      'publiccode': publiccode,
      'codetype': codetype,
      'referredid': referedid,
    };
  }
}

Future<PublicCode> getPublicCodeValue(String publiccode) {
  if (publiccode == null || publiccode == '') return null;
  return FirebaseFirestore.instance
      .collection('publiccodes')
      .doc(publiccode)
      .get()
      .then((snap) {
    if (snap.exists) {
      return PublicCode.fromData(snap.data());
    } else {
      return null;
    }
  });
  /*
  return FirebaseFunctions.instance
      .httpsCallable( "getPublicCode")
      .call({
    'publiccode': publiccode,
  }).then((result) {
    if (result.data == null) return null;
    PublicCode newcode =
        PublicCode.fromData(result.data.cast<String, dynamic>());
    return newcode;
  }).catchError((error) {
    print(error);
    return null;
  });
  */
}

Future<PublicCode> generatePublicCode(
    {required String id, required int codetype}) {
  return FirebaseFunctions.instance.httpsCallable('generatePublicCode').call({
    'codetype': codetype,
    'id': id,
  }).then((result) {
    final newcode = PublicCode.fromData(result.data.cast<String, dynamic>());
    return newcode;
  }).catchError((error) {
    return Future.error(error);
  });
}

Future<bool> removePublicCode({required String id, required int codetype}) {
  return FirebaseFunctions.instance.httpsCallable('removePublicCode').call({
    'codetype': codetype,
    'id': id,
  }).then((result) {
    if (result.data == null) {
      return false;
    } else {
      return true;
    }
  }).catchError((error) {
    return Future.error(error);
  });
}
