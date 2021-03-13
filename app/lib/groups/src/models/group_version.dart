import 'package:schulplaner_addons/common/model.dart';

enum GroupVersion { outdated, v3 }

GroupVersion groupVersionFromData(String data) =>
    enumFromString(GroupVersion.values, data)!;

String groupVersionToData(GroupVersion groupVersion) =>
    enumToString(groupVersion)!;
