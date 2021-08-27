typedef GradeValue GetGradeValue(String gradevalueid);

class GradeValue {
  final String id, name;
  final String? name2;
  final int gradepackage;
  final double value;
  final double? value_notendency;
  const GradeValue({
    required this.id,
    required this.name,
    this.name2,
    required this.gradepackage,
    required this.value,
    this.value_notendency,
  });

  String getLongName() {
    if (name2 == null) {
      return name;
    } else {
      return name + ' ($name2)';
    }
  }

  String getKey() {
    return id;
  }
}
