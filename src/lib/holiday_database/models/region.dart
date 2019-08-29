import 'package:schulplaner/holiday_database/models/country.dart';
import 'package:schulplaner/utils/models/id.dart';
import 'package:schulplaner/utils/models/name.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner/utils/models/errors.dart';
import 'package:schulplaner/utils/models/date.dart';
import 'package:schulplaner/utils/models/coder.dart';

class Region {
  final ID id;
  final Name name;
  final Country country;
  final Date lastRefreshed;
  final List<String> years;

  const Region({
    @required this.id,
    @required this.name,
    @required this.country,
    @required this.lastRefreshed,
    @required this.years,
  });
}

class RegionConverter {
  static Region fromJson(dynamic json) {
    if (json == null) throw InvalidJsonParseError();
    return Region(
      id: ID(json['id']),
      name: Name(json['name']),
      country: countryFromJson(json['country']),
      lastRefreshed: Date(json['lastRefreshed']),
      years: decodeList(json['years'], (it) => it),
    );
  }

  static Map<String, dynamic> toJson(Region region) {
    return {
      'id': region.id.key,
      'name': region.name.text,
      'country': countryToJson(region.country),
      'lastRefreshed': region.lastRefreshed.toDateString,
      'years': region.years,
    };
  }
}
