import 'package:schulplaner8/Data/Planner/File.dart';

class AbsentTime {
  late String id;
  late String? date;
  late String? detail;
  late bool unexcused;
  late int? amount;
  late Map<String, CloudFile?>? files;

  AbsentTime({
    required this.id,
    this.date,
    this.amount,
    this.detail,
    this.files,
    this.unexcused = true,
  });

  AbsentTime.fromData(Map<String, dynamic> data) {
    id = data['id'];
    date = data['date'] ?? data['datestring'];
    detail = data['detail'];
    unexcused = data['unexcused'];
    amount = data['amount'];
    //datamaps:
    Map<String, dynamic> premap_files =
        data['files']?.cast<String, dynamic>() ?? {};
    premap_files.removeWhere((key, value) => value == null);
    files = premap_files.map<String, CloudFile>((String key, value) =>
        MapEntry(key, CloudFile.fromData(value?.cast<String, dynamic>())));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'detail': detail,
        'unexcused': unexcused,
        'amount': amount,
        'files': files?.map((key, value) => MapEntry(key, value?.toJson())),
      };

  bool validate() {
    if (id == '') return false;
    if (date == null || date == '') return false;
    if (amount == null || (amount ?? -1) < 0) return false;
    return true;
  }

  AbsentTime copy() {
    return AbsentTime(
      id: id,
      date: date,
      detail: detail,
      unexcused: unexcused,
      amount: amount,
      files: files,
    );
  }
}
