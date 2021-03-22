//CODETYPE 0 = COURSE, 1 = CLASS

class PublicCode {
  late String publiccode;
  late int codetype;
  late String referedid;
  String? link;
  PublicCode(
      {required this.publiccode,
      required this.codetype,
      required this.referedid,
      this.link});

  PublicCode.fromData(Map<String, dynamic> data) {
    publiccode = data['publiccode'];
    codetype = data['codetype'];
    referedid = data['referredid'];
    link = data['link'];
  }

  Map<String, dynamic> toJson() {
    return {
      'publiccode': publiccode,
      'codetype': codetype,
      'referredid': referedid,
    };
  }
}
