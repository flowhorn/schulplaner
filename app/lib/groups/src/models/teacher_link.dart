import 'teacher.dart';

class TeacherLink {
  late String teacherid;
  late String name;

  TeacherLink({required this.teacherid, required this.name});

  factory TeacherLink.fromData({String? id, required dynamic data}) {
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
