import 'package:authentification/authentification_models.dart';

class MemberId {
  final UserId userId;
  final String plannerId;

  const MemberId({
    required this.userId,
    required this.plannerId,
  });

  String toDataString() {
    return '${userId.uid.toString()}::$plannerId';
  }
}
