//
import 'package:schulplaner8/Data/ObjectsPlanner.dart';
import 'package:schulplaner8/groups/src/models/group_version.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/groups/src/models/course_settings.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner8/models/shared_settings.dart';
import 'package:schulplaner8/utils/models/coder.dart';
import 'helper_functions.dart';

class SchoolClass {
  final String id, name, shortname;

  final Design design;
  final Map<String, bool> courses;

  final String? publiccode, description, joinLink;
  final bool creatorRequiresAdmin;
  final bool enablechat;

  final List<String> membersList;
  final Map<String, MemberData> membersData;
  final Map<String, MemberRole> userRoles;

  final CourseSettings settings;
  final SharedSettings sharedSettings;
  final GroupVersion groupVersion;

  const SchoolClass._({
    required this.id,
    required this.name,
    required this.design,
    required this.shortname,
    required this.courses,
    required this.publiccode,
    required this.joinLink,
    required this.description,
    required this.membersList,
    required this.membersData,
    required this.userRoles,
    required this.creatorRequiresAdmin,
    required this.enablechat,
    required this.settings,
    required this.sharedSettings,
    required this.groupVersion,
  });

  factory SchoolClass.Create(
      String id, PlannerSettingsData settingsData, String authorID) {
    return SchoolClass._(
      id: id,
      name: '',
      design: getRandomDesign(),
      shortname: '',
      courses: {},
      publiccode: null,
      joinLink: null,
      description: null,
      membersList: [],
      membersData: {},
      userRoles: {},
      creatorRequiresAdmin: false,
      enablechat: false,
      settings: CourseSettings.standard,
      sharedSettings: SharedSettings.Create(settingsData, authorID),
      groupVersion: GroupVersion.v3,
    );
  }

  factory SchoolClass.fromData(Map<String, dynamic> data) {
    //MAPS:
    Map<String, dynamic> predata_courses =
        data['courses']?.cast<String, dynamic>();
    Map<String, bool> courses = (predata_courses ?? {}).map<String, bool>(
        (String key, dynamic value) => MapEntry<String, bool>(key, value));
    courses?.removeWhere((key, value) => value != true);

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

    return SchoolClass._(
      id: data['classid'],
      name: data['name'],
      design: Design.fromData(data['design']?.cast<String, dynamic>()),
      shortname: data['shortname'],
      courses: courses,
      publiccode: data['publiccode'],
      joinLink: data['joinLink'],
      description: data['description'],
      membersData: membersData,
      membersList: decodeList(data['membersList'], (value) => value),
      userRoles: decodeMap<MemberRole>(
        data['userRoles'],
        (key, value) => memberRoleEnumFromString(value),
      ),
      creatorRequiresAdmin: data['creatorrequiresadmin'] ?? false,
      enablechat: data['enablechat'] ?? false,
      settings: CourseSettings.fromData(data['settings']),
      sharedSettings: SharedSettings.FromData(
        data['sharedSettings'],
      ),
      groupVersion: groupVersionFromData(data['groupVersion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classid': id,
      'name': name,
      'shortname': shortname,
      'courses': courses?.cast<String, bool>(),
      'design': design.toJson(),
      'publiccode': publiccode,
      'description': description,
      'creatorrequiresadmin': creatorRequiresAdmin,
      'enablechat': enablechat,
      'membersList': membersList,
      'membersData': encodeMap<MemberData>(membersData, (it) => it.toJson()),
      'userRoles':
          encodeMap<MemberRole>(userRoles, (it) => memberRoleEnumToString(it)),
      'settings': settings.toJson(),
      'sharedSettings': sharedSettings?.toJson(),
      'groupVersion': groupVersionToData(groupVersion),
    };
  }

  Map<String, dynamic> toJson_OnlyInfos() {
    return {
      'name': name,
      'shortname': shortname,
      'design': design.toJson(),
      'description': description,
    };
  }

  bool validate() {
    if (id == null) return false;
    if (name == null || name == '') return false;
    if (design == null) return false;
    return true;
  }

  SchoolClass copyWith({
    String? id,
    String? name,
    Design? design,
    String? shortname,
    Map<String, bool>? courses,
    String? publiccode,
    String? description,
    List<String>? membersList,
    Map<String, MemberData>? membersData,
    Map<String, MemberRole>? userRoles,
    bool? creatorRequiresAdmin,
    bool? enablechat,
    CourseSettings? settings,
  }) {
    return SchoolClass._(
      id: id ?? this.id,
      name: name ?? this.name,
      courses: courses ?? this.courses,
      shortname: shortname ?? this.shortname,
      design: design ?? this.design,
      publiccode: publiccode ?? this.publiccode,
      joinLink: joinLink,
      description: description ?? this.description,
      creatorRequiresAdmin: creatorRequiresAdmin ?? this.creatorRequiresAdmin,
      membersList: membersList ?? this.membersList,
      membersData: membersData ?? this.membersData,
      userRoles: userRoles ?? this.userRoles,
      enablechat: enablechat ?? this.enablechat,
      settings: settings ?? this.settings,
      sharedSettings: sharedSettings,
      groupVersion: groupVersion,
    );
  }

  String getShortname({int length = 2}) {
    String text = shortname ?? name ?? '-';
    return text.substring(0, text.length > length ? length : text.length);
  }

  String getShortname_full() {
    String text = shortname ?? name ?? '-';
    return text;
  }

  String getName() {
    return name;
  }

  Design getDesign() {
    return design;
  }
}
