class SchoolReport {
  final String id;
  final String name;
  final Map<String, ReportValue> values;
  const SchoolReport(
      {required this.id, required this.name, required this.values});

  factory SchoolReport.fromData(Map<String, dynamic> data) {
    final id = data['id'];
    final name = data['name'];

    //DATAMAPS
    Map<String, dynamic> premap_data =
        (data['values'] ?? data['data'])?.cast<String, dynamic>() ?? {};
    premap_data.removeWhere((key, value) => value == null);
    final values = premap_data.map<String, ReportValue>((String key, value) =>
        MapEntry(key, ReportValue.fromData(value?.cast<String, dynamic>())));
    return SchoolReport(
      id: id,
      name: name,
      values: values,
    );
  }

  SchoolReport copyWith(
      {String? id, String? name, Map<String, ReportValue>? values}) {
    return SchoolReport(
      id: id ?? this.id,
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }

  bool validate() {
    if (id == null || id == '') return false;
    if (name == null || name == '') return false;
    return true;
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'values': values.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  ReportValue? getValue(String courseid) {
    if (values[courseid] == null) return null;
    return values[courseid];
  }
}

class ReportValue {
  final String? grade_key;
  final double weight;

  const ReportValue({this.grade_key, required this.weight});

  factory ReportValue.fromData(Map<String, dynamic> data) {
    final grade_key = data['grade_key'];
    var internalweight = data['weight'];
    final weight = double.parse(internalweight.toString());
    return ReportValue(
      weight: weight,
      grade_key: grade_key,
    );
  }

  bool validate() {
    if (grade_key == null || grade_key == '') return false;
    if (weight == null) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_key': grade_key,
      'weight': weight,
    };
  }

  ReportValue copyWith({
    final String? grade_key,
    final double? weight,
  }) {
    return ReportValue(
      grade_key: grade_key ?? this.grade_key,
      weight: weight ?? this.weight,
    );
  }
}
