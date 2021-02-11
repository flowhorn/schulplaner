import 'package:meta/meta.dart';
import 'teacher.dart';

class TeacherLink {
  String teacherid, name;

  TeacherLink({this.teacherid, this.name});

  factory TeacherLink.fromData({required String id, required dynamic data}) {
    if (data == null) return null;
    return TeacherLink(
      teacherid: id ?? data['teacherid'],
      name: data['name'],
    );
  }

  TeacherLink.fromTeacher(Teacher teacher) {
    teacherid = teacher.teacherid;
    name = teacher.name;
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherid': teacherid,
      'name': name,
    };
  }
}
