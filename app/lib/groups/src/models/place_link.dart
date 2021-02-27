// @dart=2.11
import 'package:meta/meta.dart';
import 'package:schulplaner8/groups/src/models/place.dart';

class PlaceLink {
  String placeid, name;

  PlaceLink({this.placeid, this.name});

  PlaceLink.fromPlace(Place item) {
    placeid = item.placeid;
    name = item.name;
  }

  factory PlaceLink.fromData({@required String id, @required dynamic data}) {
    if (data == null) return null;
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
