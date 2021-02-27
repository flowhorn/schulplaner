//@dart=2.11
Map<String, T> decodeMap<T>(
    dynamic data, T Function(String key, dynamic data) builder) {
  Map<dynamic, dynamic> originaldata = data?.cast<dynamic, dynamic>();
  if (originaldata != null)
    originaldata.removeWhere((key, value) => value == null);
  Map<String, dynamic> decodedMap = (originaldata ?? {}).map<String, dynamic>(
      (dynamic key, dynamic value) => MapEntry<String, dynamic>(key, value));
  return decodedMap.map((key, value) => MapEntry(key, builder(key, value)));
}

Map<String, dynamic> encodeMap<T>(
    Map<String, T> data, dynamic Function(T item) encoder) {
  return data.map((key, it) => MapEntry(key, encoder(it)));
}

List<T> decodeList<T>(dynamic data, T Function(dynamic data) builder) {
  List<dynamic> originaldata = data;
  if (originaldata == null) return [];
  return originaldata.map((dynamic value) => builder(value)).toList();
}

List<dynamic> encodeList<T>(List<T> data, dynamic Function(T item) encoder) {
  return data.map((it) => encoder(it)).toList();
}

T enumFromString<T>(List<T> values, String json, {T orElse}) => json != null
    ? values.firstWhere(
        (it) =>
            '$it'.split(".")[1].toString().toLowerCase() == json.toLowerCase(),
        orElse: () => orElse)
    : null;

String enumToString<T>(T value) =>
    value != null ? value.toString().split('\.')[1] : null;
