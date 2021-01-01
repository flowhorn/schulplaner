import 'dart:math';

import 'package:uuid/uuid.dart';

String randomID() {
  return Random.secure().nextInt(999999999).toString();
}

String randomUUID() {
  return Uuid().v4();
}
