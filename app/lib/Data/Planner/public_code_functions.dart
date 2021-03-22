import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner_functions/schulplaner_functions.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class PublicCodeFunctions {
  final SchulplanerFunctionsBloc schulplanerFunctionsBloc;

  const PublicCodeFunctions(this.schulplanerFunctionsBloc);

  static Future<PublicCode?> getPublicCodeValue(String? publiccode) {
    if (publiccode == null || publiccode == '') return Future.value(null);
    return FirebaseFirestore.instance
        .collection('publiccodes')
        .doc(publiccode)
        .get()
        .then((snap) {
      if (snap.exists) {
        return PublicCode.fromData(snap.data()!);
      } else {
        return null;
      }
    });
  }

  Future<PublicCode?> generatePublicCode({
    required String id,
    required int codetype,
  }) async {
    final appFunctionsResult = await schulplanerFunctionsBloc
        .generatePublicCode(id: id, codetype: codetype);
    if (appFunctionsResult.hasData) {
      final newcode =
          PublicCode.fromData(appFunctionsResult.data.cast<String, dynamic>());
      return newcode;
    }
    if (appFunctionsResult.hasException) {}
    return null;
  }

  Future<bool> removePublicCode({
    required String id,
    required int codetype,
  }) async {
    final appFunctionsResult = await schulplanerFunctionsBloc.removePublicCode(
        id: id, codetype: codetype);
    if (appFunctionsResult.hasData) {
      print(appFunctionsResult.data);
      return true;
    }
    return false;
  }
}
