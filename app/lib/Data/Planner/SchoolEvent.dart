import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

enum EventTypes { OTHER, EXAM, TEST, TRIP }

class EventTypeData {
  int id;
  String name;
  IconData iconData;
  EventTypeData({this.id, this.name, this.iconData});
}

Map<int, EventTypeData> eventtype_data(BuildContext context) {
  return {
    0: EventTypeData(
        id: 0, name: getString(context).default_, iconData: Icons.label),
    1: EventTypeData(
        id: 1, name: getString(context).exam, iconData: Icons.stars),
    2: EventTypeData(
        id: 2, name: getString(context).test, iconData: Icons.sort),
    3: EventTypeData(id: 3, name: getString(context).trip, iconData: Icons.map),
  };
}

class SchoolEvent {
  String eventid, title, date, courseid, classid, creatorid;
  String detail;
  String enddate, starttime, endtime;
  int type;
  bool archived, private;
  Map<String, CloudFile> files;

  SchoolEvent({
    this.eventid,
    this.title,
    this.date,
    this.classid,
    this.courseid,
    this.detail,
    this.type,
    this.archived = false,
    this.private = false,
    this.files,
    this.creatorid,
    this.starttime,
    this.enddate,
    this.endtime,
  });

  SchoolEvent.fromData(Map<String, dynamic> data) {
    eventid = data['eventid'];
    title = data['title'];
    date = data['date'];
    classid = data['classid'];
    type = data['type'];
    courseid = data['courseid'];
    creatorid = data['creatorid'];
    detail = data['detail'];

    enddate = data['enddate'];
    starttime = data['starttime'];
    endtime = data['endtime'];

    archived = data['archived'] ?? false;
    private = data['private'] ?? false;

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
          final attachments = rawdata.map<String, CloudFile>(
              (key, value) => MapEntry<String, CloudFile>(
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
          final attachments = rawdata.map<String, CloudFile>(
              (key, value) => MapEntry<String, CloudFile>(
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
      'eventid': eventid,
      'title': title,
      'date': date,
      'classid': classid,
      'courseid': courseid,
      'creatorid': creatorid,
      'detail': detail,
      'type': type,
      'files': files?.map((key, value) => MapEntry(key, value?.toJson())),
      'archived': archived,
      'private': private,
      'starttime': starttime,
      'endtime': endtime,
      'enddate': enddate,
    };
  }

  SchoolEvent copy() {
    return SchoolEvent(
      eventid: eventid,
      title: title,
      date: date,
      classid: classid,
      courseid: courseid,
      detail: detail,
      type: type,
      archived: archived,
      private: private,
      files: files != null ? Map.of(files) : null,
      creatorid: creatorid,
      enddate: enddate,
      starttime: starttime,
      endtime: endtime,
    );
  }

  bool validateCreate() {
    if (private == true) {
      if (title == null || title == '') return false;
      if (date == null) return false;
      if (type == null) return false;
      if (enddate != null && date != null) {
        var diff = parseDate(enddate).difference(parseDate(date));
        if (diff > Duration(days: 7)) return false;
      }
      return true;
    } else {
      if (title == null || title == '') return false;
      if (date == null) return false;
      if (courseid == null && classid == null) return false;
      if (type == null) return false;
      if (enddate != null && date != null) {
        var diff = parseDate(enddate).difference(parseDate(date)).abs();
        if (diff > Duration(days: 7)) return false;
      }
      return true;
    }
  }

  List<String> getDateKeys() {
    var start = parseDate(date);
    final end = parseDate(enddate ?? date);
    final items = <String>[];
    if (end.isBefore(start)) return [date];
    if (start.difference(end).abs() > Duration(days: 7)) return [date];
    while (!start.isAfter(end)) {
      items.add(parseDateString(start));
      start = start.add(Duration(days: 1));
    }
    return items;
  }

  bool validate() {
    if (eventid == null) return false;
    if (date == null) return false;
    if (title == null || title == '') return false;
    if (type == null) return false;
    if (enddate != null && date != null) {
      var diff = parseDate(enddate).difference(parseDate(date)).abs();
      if (diff > Duration(days: 7)) return false;
    }
    return true;
  }
}
