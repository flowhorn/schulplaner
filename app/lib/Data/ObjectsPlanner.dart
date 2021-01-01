import 'package:meta/meta.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class CoursePersonal {
  String courseid, shortname, gradeprofileid;
  Design design;

  CoursePersonal(
      {@required this.courseid,
      this.design,
      this.shortname,
      this.gradeprofileid});

  CoursePersonal.fromData(Map<String, dynamic> data) {
    courseid = data['courseid'];
    shortname = data['shortname'];
    gradeprofileid = data['gradeprofileid'];
    design = data['design'] != null
        ? Design.fromData(data['design']?.cast<String, dynamic>())
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'courseid': courseid,
      'shortname': shortname,
      'gradeprofileid': gradeprofileid,
      'design': design?.toJson(),
    };
  }

  bool validate() {
    if (courseid == null) return false;
    return true;
  }

  CoursePersonal copy() {
    return CoursePersonal(
      courseid: courseid,
      shortname: shortname,
      gradeprofileid: gradeprofileid,
      design: design,
    );
  }
}

/*
class Term{
  String termid, name, start, end;

  Term({this.termid, this.name, this.start, this.end});

  Term.fromData(Map<String, dynamic>data){
    termid = data['termid'];
    name = data['name'];
    start = data['start'];
    end = data['end'];
  }

  Map<String, dynamic> toJson(){
    return{
      'termid':termid,
      'name':name,
      'start':start,
      'end':end,
    };
  }

  bool validate(){
    if(termid == null)return false;
    if(name ==null || name == "")return false;
    if(start ==null || start == "")return false;
    if(end ==null || end == "")return false;
    return true;
  }
}
 */

class CourseMember {
  String memberid;
  int membertype;

  CourseMember({this.memberid, this.membertype});

  CourseMember.fromData(dynamic data) {
    memberid = data['memberid'];
    membertype = data['membertype'];
  }

  Map<String, dynamic> toJson() {
    return {
      'memberid': memberid,
      'membertype': membertype,
    };
  }

  String getUid() {
    return memberid.split("::")[0];
  }

  String getPlannerId() {
    return memberid.split("::")[1];
  }

  static getUidFromKey(String key) {
    if (key.startsWith("ADVANCED=")) {
      return key.split("=")[1].split(":")[0];
    } else {
      return key;
    }
  }

  static getPlannerIDFromKey(String key) {
    if (key.startsWith("ADVANCED=")) {
      return key.split("=")[1].split(":")[1];
    } else {
      return key;
    }
  }
}
