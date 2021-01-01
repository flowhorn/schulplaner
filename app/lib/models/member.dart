import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/models/additionaltypes.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

@immutable
class MemberData {
  final String id, pic, picThumb, avatar;
  final ProfileDisplayMode displayMode;
  final String name;
  final MemberRole role;
  final DateTime joinedOn;
  /*
  HERE THE MEMBERTYPE AND PERMISSIONS WILL BE STORED e.g.
  final MemberRole role;
  final MemberPermissions permissions; 
  THESE CAN BE CUSTOM OR DEFAULT ROLES LIKE = "admin" / "standard" / "none" / "parent" / "custom"
  */

  const MemberData({
    @required this.id,
    @required this.name,
    @required this.role,
    @required this.pic,
    @required this.picThumb,
    @required this.avatar,
    @required this.displayMode,
    @required this.joinedOn,
  });

  factory MemberData.create({@required String id, @required MemberRole role}) {
    return MemberData(
      id: id,
      name: "",
      role: role,
      pic: null,
      picThumb: null,
      avatar: null,
      displayMode: ProfileDisplayMode.none,
      joinedOn: DateTime.now(),
    );
  }

  factory MemberData.fromData({@required String id, @required dynamic data}) {
    return MemberData(
      id: id,
      name: data['name'],
      role: memberRoleEnumFromString(data['role'] ?? 'admin'),
      pic: data['pic'],
      picThumb: data['picThumb'],
      avatar: data['avatar'],
      displayMode:
          profileDisplayModeEnumFromString(data['displayMode'] ?? 'avatar'),
      joinedOn: ((data['joinedOn'] ?? Timestamp.now()) as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': memberRoleEnumToString(role),
      'pic': pic,
      'picThumb': picThumb,
      'avatar': avatar,
      'displayMode': profileDisplayModeEnumToString(displayMode),
      'joinedOn': Timestamp.fromDate(joinedOn),
    };
  }

  MemberData copyWith({
    String name,
    pic,
    picThumb,
    avatar,
    ProfileDisplayMode displayMode,
    DateTime joinedOn,
    MemberData role,
  }) {
    return MemberData(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      pic: pic ?? this.pic,
      picThumb: picThumb ?? this.picThumb,
      avatar: avatar ?? this.avatar,
      displayMode: displayMode ?? this.displayMode,
      joinedOn: joinedOn ?? this.joinedOn,
    );
  }

  String getUid() {
    return id.split("::")[0];
  }

  String getPlannerId() {
    return id.split("::")[1];
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
