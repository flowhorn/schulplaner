class Place {
  String placeid, name, address;

  Place({this.placeid, this.name, this.address});

  Place.fromData(Map<String, dynamic> data) {
    placeid = data['placeid'];
    name = data['name'];
    address = data['address'];
  }

  Map<String, dynamic> toJson() {
    return {
      'placeid': placeid,
      'name': name,
      'address': address,
    };
  }

  bool validate() {
    if (placeid == null) return false;
    if (name == null || name == '') return false;
    return true;
  }
}
