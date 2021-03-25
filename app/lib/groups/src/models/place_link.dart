//
import 'package:meta/meta.dart';
import 'package:schulplaner8/groups/src/models/place.dart';

class PlaceLink {
  late String placeid, name;

  PlaceLink({required this.placeid, required this.name});

  PlaceLink.fromPlace(Place item) {
    placeid = item.placeid;
    name = item.name;
  }

  factory PlaceLink.fromData({String? id, required dynamic data}) {
    return PlaceLink(
      placeid: id ?? data['teacherid'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeid': placeid,
      'name': name,
    };
  }
}
