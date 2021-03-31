//
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Data/ObjectsPlanner.dart';
import 'package:schulplaner8/Data/Planner/CourseTemplates.dart';
import 'package:schulplaner8/groups/src/models/group_version.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/OldRest/OldDesign.dart';
import 'package:schulplaner8/models/helper_functions.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/utils/models/coder.dart';

import 'course_settings.dart';
import 'place_link.dart';
import 'teacher_link.dart';

@immutable
class Course {
  final String id, name, title;
  final String? shortname;
  final String? publiccode, description, joinLink;
  final String? personalshortname, personalgradeprofile;
  final DateTime createdOn;

  final Design? design;
  final Design? personaldesign;
  final List<String> membersList;
  final Map<String, MemberData> membersData;
  final Map<String, MemberRole> userRoles;
  final CourseSettings settings;

  final Map<String, bool> connectedclasses;
  final Map<String, Lesson> lessons;
  final Map<String, TeacherLink?> teachers;
  final Map<String, PlaceLink?> places;
  final GroupVersion groupVersion;

  const Course._({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.shortname,
    required this.publiccode,
    required this.joinLink,
    required this.createdOn,
    required this.membersList,
    required this.membersData,
    required this.userRoles,
    required this.settings,
    required this.lessons,
    required this.personalshortname,
    required this.personalgradeprofile,
    required this.design,
    required this.personaldesign,
    required this.connectedclasses,
    required this.teachers,
    required this.places,
    required this.groupVersion,
  });

  factory Course.create({required String id}) {
    return Course._(
      id: id,
      name: '',
      title: '',
      description: '',
      shortname: null,
      publiccode: null,
      joinLink: null,
      createdOn: DateTime.now(),
      membersList: [],
      membersData: {},
      userRoles: {},
      settings: CourseSettings.standard,
      lessons: {},
      personalshortname: null,
      personalgradeprofile: null,
      design: null,
      personaldesign: null,
      connectedclasses: {},
      teachers: {},
      places: {},
      groupVersion: GroupVersion.v3,
    );
  }

  factory Course.fromData(dynamic data) {
    return CourseConverter.fromData(data);
  }

  factory Course.fromTemplate(
      {required String courseid, required CourseTemplate template}) {
    return Course._(
      id: courseid,
      name: template.name,
      title: '',
      description: '',
      shortname: template.shortname,
      publiccode: null,
      joinLink: null,
      createdOn: DateTime.now(),
      membersList: [],
      membersData: {},
      userRoles: {},
      settings: CourseSettings.standard,
      lessons: {},
      personalshortname: null,
      personalgradeprofile: null,
      design: template.design,
      personaldesign: null,
      connectedclasses: {},
      teachers: {},
      places: {},
      groupVersion: GroupVersion.v3,
    );
  }

  Course copyWith({
    String? name,
    title,
    description,
    shortname,
    String? publiccode,
    DateTime? createdOn,
    List<String>? membersList,
    Map<String, MemberData>? membersData,
    Map<String, MemberRole>? userRoles,
    CourseSettings? settings,
    Map<String, Lesson>? lessons,
    String? personalshortname,
    personalgradeprofile,
    Design? design,
    personaldesign,
    Map<String, bool>? connectedclasses,
    Map<String, TeacherLink>? teachers,
    Map<String, PlaceLink>? places,
  }) {
    return Course._(
      id: id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      shortname: shortname ?? this.shortname,
      publiccode: publiccode ?? this.publiccode,
      joinLink: joinLink,
      createdOn: createdOn ?? this.createdOn,
      membersList: membersList ?? this.membersList,
      membersData: membersData ?? this.membersData,
      userRoles: userRoles ?? this.userRoles,
      settings: settings ?? this.settings,
      lessons: lessons ?? this.lessons,
      design: design ?? this.design,
      personalshortname: personalshortname ?? this.personalshortname,
      personaldesign: personaldesign ?? this.personaldesign,
      personalgradeprofile: personalgradeprofile ?? this.personalgradeprofile,
      connectedclasses: connectedclasses ?? this.connectedclasses,
      teachers: teachers ?? this.teachers,
      places: places ?? this.places,
      groupVersion: groupVersion,
    );
  }

  Course copyWithNull({
    Design? personaldesign,
    String? personalshortname,
    String? personalgradeprofile,
  }) {
    return Course._(
      id: id,
      name: name,
      title: title,
      teachers: teachers,
      places: places,
      joinLink: joinLink,
      shortname: shortname,
      design: design,
      personaldesign: personaldesign,
      personalshortname: personalshortname,
      personalgradeprofile: personalgradeprofile,
      publiccode: publiccode,
      description: description,
      connectedclasses: connectedclasses,
      lessons: lessons,
      settings: settings,
      createdOn: createdOn,
      membersData: membersData,
      membersList: membersList,
      userRoles: userRoles,
      groupVersion: groupVersion,
    );
  }

  bool validate() {
    if (id == null) return false;
    if (name == null || name == '') return false;
    if (design == null) return false;
    return true;
  }

  String getShortname_full() {
    String text = personalshortname ?? shortname ?? name;
    return text;
  }

  String getName() {
    return name;
  }

  Design? getDesign() {
    return personaldesign ?? design;
  }

  List<TeacherLink> getTeacherLinks() {
    return teachers.values.where((it) => it != null).toList()
        as List<TeacherLink>;
  }

  List<PlaceLink> getPlaceLinks() {
    return places.values.where((it) => it != null).toList() as List<PlaceLink>;
  }

  String getTeachersListed() {
    final text = teachers.values.map((data) => data?.name ?? '-').join(', ');
    if (text == null || text == '') {
      return '-';
    } else {
      return text;
    }
  }

  String getPlacesListed() {
    final text = places.values.map((data) => data?.name ?? '-').join(', ');
    if (text == '') {
      return '-';
    } else {
      return text;
    }
  }

  String? getTeacherFirst() {
    final list = getTeacherLinks();
    if (list.isNotEmpty) {
      return list[0].name;
    } else {
      return null;
    }
  }

  TeacherLink? getTeacherFirstItem() {
    List<TeacherLink> list = getTeacherLinks();
    if (list.isNotEmpty) {
      return list[0];
    } else {
      return null;
    }
  }

  String? getPlaceFirst() {
    final list = getPlaceLinks();
    if (list.isNotEmpty) {
      return list[0].name;
    } else {
      return null;
    }
  }

  PlaceLink? getPlaceFirstItem() {
    final list = getPlaceLinks();
    if (list.isNotEmpty) {
      return list[0];
    } else {
      return null;
    }
  }
}

Design _getDesign(dynamic data) {
  if (data['olddata'] != null) {
    OldDesign oldDesign =
        DataUtil_Design.decodeDesignHash(data['olddata']['designid']);
    if (oldDesign != null) {
      return Design(
        name: oldDesign.name!,
        primary: oldDesign.primary!,
        accent: oldDesign.accent,
      );
    }
  }
  final newDesignData = data['design'];
  if (newDesignData != null) {
    return Design.fromData(newDesignData);
  } else {
    return Design.fromData(null);
  }
}

Map<String, PlaceLink> _getPlacesMap(dynamic data) {
  final placesMap = decodeMap(
      data['places'], (key, value) => PlaceLink.fromData(id: key, data: value));
  placesMap.removeWhere((key, value) => value == null);
  return placesMap;
}

Map<String, TeacherLink> _getTeachersMap(dynamic data) {
  final teachersMap = decodeMap(data['teachers'],
      (key, value) => TeacherLink.fromData(id: key, data: value));
  teachersMap.removeWhere((key, value) => value == null);
  return teachersMap;
}

Map<String, Lesson> _getLessonsMap(dynamic data) {
  final lessonsMap = decodeMap(
      data['lessons'], (key, value) => Lesson.fromData(id: key, data: value));
  lessonsMap.removeWhere((key, value) => value == null);
  return lessonsMap;
}

extension CourseConverter on Course {
  static Course fromData(dynamic data) {
    String mShortname = data['shortname'];

    Map<String, MemberData> membersData = decodeMap(data['membersData'],
        (key, value) => MemberData.fromData(id: key, data: value));
    Map<String, OldCourseMember> oldMembers = decodeMap(
        data['members'], (key, value) => OldCourseMember.fromData(value));
    for (final courseMember in oldMembers.values) {
      if (!membersData.containsKey(courseMember.memberid)) {
        membersData[courseMember.memberid] = MemberData.create(
          id: courseMember.memberid,
          role: memberRoleFromMemberType(courseMember.membertype),
        );
      }
    }
    return Course._(
      id: data['id'] ?? data['courseid'],
      name: data['name'],
      title: data['title'],
      description: data['description'],
      shortname: data['shortname'] ?? mShortname,
      publiccode: data['publiccode'],
      joinLink: data['joinLink'],
      createdOn: ((data['createdOn'] ?? Timestamp.now()) as Timestamp).toDate(),
      membersList: decodeList(data['membersList'], (value) => value),
      membersData: membersData,
      userRoles: decodeMap<MemberRole>(
        data['userRoles'],
        (key, value) => memberRoleEnumFromString(value),
      ),
      settings: CourseSettings.fromData(data['settings']),
      lessons: _getLessonsMap(data),
      personalshortname: null,
      personalgradeprofile: null,
      personaldesign: null,
      design: _getDesign(data),
      teachers: _getTeachersMap(data),
      places: _getPlacesMap(data),
      connectedclasses:
          decodeMap(data['connectedclasses'], (key, value) => value),
      groupVersion: groupVersionFromData(data['groupVersion']),
    );
  }

  Map<String, dynamic> toJson_OnlyInfo() {
    return {
      'name': name,
      'title': title,
      'design': design?.toJson(),
      'description': description,
      'shortname': shortname != '' ? shortname : null,
      'teachers': encodeMap<TeacherLink?>(teachers, (it) => it?.toJson()),
      'places': encodeMap<PlaceLink?>(places, (it) => it?.toJson()),
    };
  }

  Map<String, dynamic> toPrimitiveJson() {
    return {
      'id': id,
      'name': name,
      'shortname': personalshortname ?? shortname,
      'design': personaldesign?.toJson() ?? design?.toJson(),
      'teachers': encodeMap<TeacherLink?>(teachers, (it) => it?.toJson()),
      'places': encodeMap<PlaceLink?>(places, (it) => it?.toJson()),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseid': id,
      'name': name,
      'title': title,
      'description': description,
      'shortname': shortname != '' ? shortname : null,
      'publiccode': publiccode,
      'design': design?.toJson(),
      'teachers': encodeMap<TeacherLink?>(teachers, (it) => it?.toJson()),
      'places': encodeMap<PlaceLink?>(places, (it) => it?.toJson()),
      'createdOn': Timestamp.fromDate(createdOn),
      'membersList': membersList,
      'membersData': membersData.map(
        (key, value) => MapEntry(
          key,
          value.toJson(),
        ),
      ),
      'userRoles':
          encodeMap<MemberRole>(userRoles, (it) => memberRoleEnumToString(it)),
      'settings': settings.toJson(),
      'lessons': lessons.map((key, value) => MapEntry(key, value.toJson())),
      'groupVersion': groupVersionToData(groupVersion),
    };
  }
}
