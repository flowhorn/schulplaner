//@dart=2.11
import 'package:authentification/authentification_models.dart';
import 'package:meta/meta.dart';
import 'auth_user.dart';

abstract class AuthentificationStatus {
  const AuthentificationStatus();

  String getUid();
  UserId get userId;
}

class NotLoggedInAuthentificationStatus extends AuthentificationStatus {
  @override
  String getUid() => null;

  @override
  UserId get userId => null;
}

class LoadingAuthentificationStatus extends AuthentificationStatus {
  @override
  String getUid() => null;
  @override
  UserId get userId => null;
}

class AuthentifiedAuthentificationStatus extends AuthentificationStatus {
  const AuthentifiedAuthentificationStatus({@required this.authUser});
  final AuthUser authUser;

  @override
  String getUid() => authUser.userId.uid;
  @override
  UserId get userId => authUser.userId;
}
