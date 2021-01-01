import 'package:cloud_firestore/cloud_firestore.dart';

typedef ObjectBuilder<T> = T Function(String key, dynamic decodedMapValue);
typedef ObjectEncoder<T> = dynamic Function(T decodedMapValue);

Map<String, T> decodeMapWithNull<T>(dynamic data, ObjectBuilder<T> builder) {
  Map<dynamic, dynamic> originaldata = data?.cast<dynamic, dynamic>();
  if (originaldata != null) {
    originaldata.removeWhere((key, value) => value == null);
  }
  Map<String, dynamic> decodedMap = (originaldata ?? {}).map<String, dynamic>(
      (dynamic key, dynamic value) => MapEntry<String, dynamic>(key, value));
  return decodedMap.map((key, value) => MapEntry(key, builder(key, value)));
}

Map<String, dynamic> encodeMap<T>(
    Map<String, T> data, ObjectEncoder<T> encoder) {
  return (data ?? {}).map(
      (key, value) => MapEntry(key, value != null ? encoder(value) : null));
}

DateTime dateTimeFromTimestamp(Timestamp timestamp) =>
    (timestamp ?? Timestamp.now()).toDate();
Timestamp timestampFromDateTime(DateTime dateTime) =>
    Timestamp.fromDate(dateTime);

double parseDoubleFrom(value) {
  return double.parse(value.toString());
}
