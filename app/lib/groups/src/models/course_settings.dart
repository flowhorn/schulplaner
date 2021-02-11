import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

@immutable
class CourseSettings {
  final bool isPublic, onlyVerifiedMembers;
  final DateTime lastChanged;
  final MemberRole defaultRole;

  const CourseSettings._(
      {required this.isPublic,
      required this.lastChanged,
      required this.onlyVerifiedMembers,
      required this.defaultRole});

  static final CourseSettings standard = CourseSettings._(
      isPublic: true,
      lastChanged: DateTime.now(),
      onlyVerifiedMembers: false,
      defaultRole: MemberRole.standard);

  factory CourseSettings.fromData(dynamic data) {
    if (data == null) return standard;
    return CourseSettings._(
        isPublic: data['isPublic'],
        defaultRole: memberRoleEnumFromString(data['defaultRole']),
        onlyVerifiedMembers: data['onlyVerifiedMembers'],
        lastChanged:
            ((data['lastChanged'] ?? Timestamp.now()) as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'isPublic': isPublic,
      'defaultRole': memberRoleEnumToString(defaultRole),
      'onlyVerifiedMembers': onlyVerifiedMembers,
      'lastChanged': Timestamp.fromDate(lastChanged),
    };
  }

  CourseSettings copyWith({
    bool isPublic,
    onlyVerifiedMembers,
    DateTime lastChanged,
    MemberRole defaultRole,
  }) {
    return CourseSettings._(
      isPublic: isPublic ?? this.isPublic,
      onlyVerifiedMembers: onlyVerifiedMembers ?? this.onlyVerifiedMembers,
      lastChanged: lastChanged ?? this.lastChanged,
      defaultRole: defaultRole ?? this.defaultRole,
    );
  }
}
