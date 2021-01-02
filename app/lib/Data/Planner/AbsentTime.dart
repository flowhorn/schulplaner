import 'package:schulplaner8/Data/Planner/File.dart';

class AbsentTime {
  String id, date, detail;
  bool unexcused;
  int amount;
  Map<String, CloudFile> files;

  AbsentTime(
      {this.id,
      this.date,
      this.unexcused = true,
      this.amount,
      this.detail,
      this.files});

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

  Map<String, Object> toJson() => {
        'id': id,
        'date': date,
        'detail': detail,
        'unexcused': unexcused,
        'amount': amount,
        'files': files?.map((key, value) => MapEntry(key, value.toJson())),
      };

  bool validate() {
    if (id == null || id == '') return false;
    if (date == null || date == '') return false;
    if (unexcused == null) return false;
    if (amount == null || amount < 0) return false;
    return true;
  }

  AbsentTime copy() {
    return AbsentTime(
      id: this.id,
      date: this.date,
      detail: this.detail,
      unexcused: this.unexcused,
      amount: this.amount,
      files: this.files,
    );
  }
}
