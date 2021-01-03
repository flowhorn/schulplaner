import 'package:schulplaner8/Data/Planner/File.dart';

class NoteData {
  String noteid, title, creatorid, date;
  String detail;
  bool archived;
  Map<String, CloudFile> files;

  NoteData(
      {this.noteid,
      this.title,
      this.detail,
      this.date,
      this.archived = false,
      this.files,
      this.creatorid});

  NoteData.fromData(Map<String, dynamic> data) {
    noteid = data['noteid'];
    title = data['title'];
    date = data['date'];
    creatorid = data['creatorid'];
    detail = data['detail'];
    archived = data['archived'];

    //datamaps:
    Map<String, dynamic> premap_files =
        data['files']?.cast<String, dynamic>() ?? {};
    premap_files.removeWhere((key, value) => value == null);
    files = premap_files.map<String, CloudFile>((String key, value) =>
        MapEntry(key, CloudFile.fromData(value?.cast<String, dynamic>())));

    if (data['olddata'] != null) {
      try {
        if (data['olddata']['att'] != null) {
          Map<dynamic, dynamic> rawdata = data['olddata']['att'];
          final attachments =
              rawdata.map<String, CloudFile>((key, value) => MapEntry<String, CloudFile>(
                  key,
                  CloudFile(
                    fileid: key,
                    name: value['n'] ?? key,
                    fileform: FileForm.OLDTTYPE,
                    savedin: SavedIn(type: SavedInType.PERSONAL, id: null),
                  )));
          files.addAll(attachments);
        }
        if (data['olddata']['attachments'] != null) {
          Map<dynamic, dynamic> rawdata = data['olddata']['attachments'];
          final attachments =
              rawdata.map<String, CloudFile>((key, value) => MapEntry<String, CloudFile>(
                  key,
                  CloudFile(
                    fileid: key,
                    name: key,
                    fileform: FileForm.OLDTTYPE,
                    savedin: SavedIn(type: SavedInType.PERSONAL, id: null),
                  )));
          files.addAll(attachments);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'noteid': noteid,
      'title': title,
      'date': date,
      'creatorid': creatorid,
      'detail': detail,
      'files': files?.map((key, value) => MapEntry(key, value?.toJson())),
      'archived': archived,
    };
  }

  NoteData copy() {
    return NoteData(
      noteid: noteid,
      title: title,
      detail: detail,
      date: date,
      archived: archived,
      files: files != null ? Map.of(files) : null,
    );
  }

  bool validate() {
    if (noteid == null) return false;
    if (title == null || title == '') return false;
    return true;
  }
}
