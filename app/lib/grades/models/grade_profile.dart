import 'package:schulplaner8/utils/models/coder.dart';
import 'package:meta/meta.dart';

import 'grade_type_item.dart';

class GradeProfile {
  final String profileid, name;
  final bool averagebytype;
  final double weight_totalaverage;
  final Map<String, GradeTypeItem> types;

  GradeProfile._({
    @required this.profileid,
    @required this.name,
    @required this.averagebytype,
    @required this.weight_totalaverage,
    @required this.types,
  });

  factory GradeProfile.Create(String id) {
    return GradeProfile._(
        profileid: id,
        name: '',
        averagebytype: false,
        weight_totalaverage: 1.0,
        types: {});
  }

  factory GradeProfile.fromData(dynamic data) {
    return GradeProfile._(
      profileid: data['id'],
      name: data['name'],
      averagebytype: data['averagebytype'],
      weight_totalaverage: double.parse(data['weight_totalaverage'].toString()),
      types: decodeMap(
          data['types'], (key, value) => GradeTypeItem.FromData(value)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': profileid,
      'name': name,
      'averagebytype': averagebytype,
      'weight_totalaverage': weight_totalaverage,
      'types': types.map((key, value) => MapEntry(key, value?.toJson())),
    };
  }

  String getNewTypeId() {
    for (var i = 0; i < 100; i++) {
      if (types[i.toString()] == null) return i.toString();
    }
    return null;
  }

  GradeProfile copyWith({
    String profileid,
    String name,
    bool averagebytype,
    double weight_totalaverage,
    Map<String, GradeTypeItem> types,
  }) {
    return GradeProfile._(
      profileid: profileid ?? this.profileid,
      name: name ?? this.name,
      averagebytype: averagebytype ?? this.averagebytype,
      weight_totalaverage: weight_totalaverage ?? this.weight_totalaverage,
      types: types ?? Map.of(this.types),
    );
  }
}
