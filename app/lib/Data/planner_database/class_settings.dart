class ClassSettings {
  final String classid;
  final Map<String, bool> disabledcourses;

  const ClassSettings({
    required this.classid,
    this.disabledcourses = const {},
  });

  factory ClassSettings.fromData({
    required dynamic? data,
    required String classid,
  }) {
    if (data != null) {
      Map<String, dynamic> premap_disabledcourses =
          data['disabledcourses']?.cast<String, dynamic>() ?? {};
      premap_disabledcourses.removeWhere((key, value) => value == null);
      return ClassSettings(
        classid: classid,
        disabledcourses: premap_disabledcourses.map<String, bool>(
          (String key, value) => MapEntry(key, true),
        ),
      );
    } else {
      return ClassSettings(
        classid: classid,
        disabledcourses: {},
      );
    }
  }
}
