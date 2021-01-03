import 'dart:convert';

class AppStats {
  int openedhomepage, openedapp, addedtask;

  bool hidecard_rateapp,
      hidecard_shareapp,
      hidecard_socialmedia,
      hidecard_supportapp;

  AppStats({
    this.openedapp = 0,
    this.openedhomepage = 0,
    this.addedtask = 0,
    this.hidecard_socialmedia = false,
    this.hidecard_rateapp = false,
    this.hidecard_shareapp = false,
    this.hidecard_supportapp = false,
  });

  AppStats.fromString(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    openedhomepage = map['openedhomepage'] ?? 0;
    openedapp = map['openedapp'] ?? 0;
    addedtask = map['addedtask'] ?? 0;
    hidecard_rateapp = map['hidecard_rateapp'] ?? false;
    hidecard_shareapp = map['hidecard_shareapp'] ?? false;
    hidecard_socialmedia = map['hidecard_socialmedia'] ?? false;
    hidecard_supportapp = map['hidecard_supportapp'] ?? false;
  }

  String toJsonString() {
    return jsonEncode({
      'openedhomepage': openedhomepage,
      'openedapp': openedapp,
      'addedtask': addedtask,
      'hidecard_rateapp': hidecard_rateapp,
      'hidecard_shareapp': hidecard_shareapp,
      'hidecard_socialmedia': hidecard_socialmedia,
      'hidecard_supportapp': hidecard_supportapp,
    });
  }

  AppStats copy() {
    return AppStats.fromString(toJsonString());
  }
}
