Map<String, T> buildSingleMap<T>(Map<String, Map<String, T>?> initalData) {
  final newdata = <String, T>{};
  for (final entry in initalData.values) {
    if (entry != null) newdata.addAll(entry);
  }
  return newdata;
}

Map<String, T> buildSingleMapFromList<T>(List<Map<String, T>?> initalData) {
  Map<String, T> newdata = {};
  for (final entry in initalData) {
    if (entry != null) newdata.addAll(entry);
  }
  return newdata;
}
