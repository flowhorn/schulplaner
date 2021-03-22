class IndirectConnection {
  final String classid, courseid;
  final bool enabled;

  const IndirectConnection({
    required this.classid,
    required this.courseid,
    this.enabled = true,
  });

  String getKey() => classid + '--' + courseid;
}
