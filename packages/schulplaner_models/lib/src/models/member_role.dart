import 'package:schulplaner_addons/common/model.dart';

enum MemberRole { owner, admin, creator, standard, none }

MemberRole memberRoleFromMemberType(int? membertype) {
  if (membertype == null) {
    return MemberRole.standard;
  } else if (membertype == 0) {
    return MemberRole.admin;
  } else if (membertype == 1) {
    return MemberRole.standard;
  }
  throw Exception('MemberRole cant be identified!');
}

MemberRole memberRoleEnumFromString(String data) =>
    enumFromString(MemberRole.values, data)!;

String memberRoleEnumToString(MemberRole memberRole) =>
    memberRole.toString().split('.')[1];

extension MemberRoleUtilities on MemberRole {
  bool isAdminOrOwner() {
    return this == MemberRole.admin || this == MemberRole.owner;
  }
}
