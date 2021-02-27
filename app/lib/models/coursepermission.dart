import 'package:schulplaner_models/schulplaner_models.dart';

enum PermissionAccessType {
  membermanagement,
  edit,
  settings,
  creator,
}

bool requestPermission(
    {required MemberRole role, required PermissionAccessType permissiontype}) {
  if (role == null) return false;
  switch (permissiontype) {
    case PermissionAccessType.membermanagement:
      {
        return [MemberRole.owner, MemberRole.admin].contains(role);
      }
    case PermissionAccessType.edit:
      {
        return [MemberRole.owner, MemberRole.admin].contains(role);
      }
    case PermissionAccessType.settings:
      {
        return [MemberRole.owner, MemberRole.admin].contains(role);
      }
    case PermissionAccessType.creator:
      {
        return [MemberRole.owner, MemberRole.admin, MemberRole.creator]
            .contains(role);
      }
  }
  return false;
}
