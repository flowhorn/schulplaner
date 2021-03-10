import 'dart:convert';

import 'package:schulplaner_addons/common/model.dart';

class AppStats {
  int openedhomepage, openedapp, addedtask;
  Map<String, bool> hideForMonth;

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
    this.hideForMonth = const {},
  });

  factory AppStats.fromString(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return AppStats(
      openedhomepage: map['openedhomepage'] ?? 0,
      openedapp: map['openedapp'] ?? 0,
      addedtask: map['addedtask'] ?? 0,
      hidecard_rateapp: map['hidecard_rateapp'] ?? false,
      hidecard_shareapp: map['hidecard_shareapp'] ?? false,
      hidecard_socialmedia: map['hidecard_socialmedia'] ?? false,
      hidecard_supportapp: map['hidecard_supportapp'] ?? false,
      hideForMonth: decodeMap<bool>(map['hidecard_donation'], (key, it) => it),
    );
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
      'hidecard_donation': hideForMonth,
    });
  }

  bool shouldHideDonationThisMonth() {
    final currentMonth = DateTime.now().toIso8601String().substring(0, 7);
    return hideForMonth[currentMonth] == true || openedhomepage < 150;
  }

  void setHideThisMonth() {
    final currentMonth = DateTime.now().toIso8601String().substring(0, 7);
    hideForMonth[currentMonth] = true;
  }

  AppStats copy() {
    return AppStats.fromString(toJsonString());
  }
}
