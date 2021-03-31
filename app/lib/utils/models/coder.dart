//
typedef ObjectMapBuilder<T> = T Function(String key, dynamic value);
typedef ObjectBuilder<T> = T Function(dynamic value);

Map<String, T> decodeMap<T>(dynamic data, ObjectMapBuilder<T> builder) {
  if (data == null) return {};
  final originaldata = data?.cast<String, dynamic>();
  if (originaldata != null) {
    originaldata.removeWhere((key, value) => value == null);
  }
  Map<String, dynamic> decodedMap = (originaldata ?? {}).map<String, dynamic>(
      (dynamic key, dynamic value) => MapEntry<String, dynamic>(key, value));
  return decodedMap.map((key, value) => MapEntry(key, builder(key, value)));
}

List<T> decodeList<T>(dynamic data, ObjectBuilder<T> builder) {
  List<dynamic> originaldata = data;
  if (originaldata == null) return [];
  return originaldata.map((dynamic value) => builder(value)).toList();
}

T enumFromJson<T>(List<T> values, String? json, {T? orElse}) => (json != null
    ? values.firstWhere(
        (it) =>
            '$it'.split('.')[1].toString().toLowerCase() == json.toLowerCase(),
        orElse: orElse != null ? () => orElse : null)
    : orElse)!;

String? enumToJson<T>(T value) =>
    value != null ? value.toString().split('\.')[1] : null;
