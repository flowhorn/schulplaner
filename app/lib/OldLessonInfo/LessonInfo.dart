import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/OldGrade/models/choice.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/lessoninfo/edit_lesson_info_page.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/groups/src/models/place_link.dart';
import 'package:schulplaner8/groups/src/models/teacher_link.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

enum LessonInfoType { NONE, CHANGED, OUT }

List<Choice> getLessonInfoTypes(BuildContext context) {
  return [
    Choice(0, getString(context).info, iconData: Icons.info),
    Choice(1, getString(context).change, iconData: Icons.change_history),
    Choice(2, getString(context).out_lessoninfo, iconData: Icons.close),
  ];
}

Color getLessonInfoColor(LessonInfoType type) {
  switch (type) {
    case LessonInfoType.NONE:
      return Colors.green;
    case LessonInfoType.CHANGED:
      return Colors.yellow;
    case LessonInfoType.OUT:
      return Colors.red;
  }
}

class LessonInfo {
  String? id, lessonid, date, courseid;
  LessonInfoType type;
  String? note;
  PlaceLink? place;
  TeacherLink? teacher;

  LessonInfo({
    required this.id,
    this.lessonid,
    this.teacher,
    this.place,
    this.note = '',
    required this.type,
    this.courseid,
    this.date,
  });

  LessonInfo.fromData(Map<String, dynamic> data)
      : id = data['id'],
        courseid = data['cid'],
        date = data['date'],
        lessonid = data['lid'],
        teacher = data['teacher'] != null
            ? TeacherLink.fromData(id: null, data: data['teacher'])
            : null,
        place = data['place'] != null
            ? PlaceLink.fromData(id: null, data: data['place'])
            : null,
        type = LessonInfoType.values[data['type']],
        note = data['note'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cid': courseid,
      'date': date,
      'lid': lessonid,
      'teacher': teacher?.toJson(),
      'place': place?.toJson(),
      'type': type.index,
      'note': note != '' ? note : null,
    };
  }

  String getKey() => courseid! + '--' + id!;

  bool validate() {
    if (date == null || date == '') return false;
    if (lessonid == null || lessonid == '') return false;
    if (courseid == null || courseid == '') return false;
    if (type == null) return false;
    return true;
  }

  LessonInfo copy({
    String? id,
    String? lessonid,
    TeacherLink? teacher,
    PlaceLink? place,
    String? note,
    LessonInfoType? type,
    String? courseid,
    String? date,
  }) {
    return LessonInfo(
      id: id ?? this.id,
      lessonid: lessonid ?? this.lessonid,
      teacher: teacher ?? this.teacher,
      place: place ?? this.place,
      note: note ?? this.note,
      type: type ?? this.type,
      courseid: courseid ?? this.courseid,
      date: date ?? this.date,
    );
  }

  Lesson? getLesson(PlannerDatabase database) {
    if (lessonid != null && courseid != null) {
      return database.getLessons()[lessonid];
    }
    return null;
  }
}

class DataUtil_LessonInfo {
  String getKey(LessonInfo item) => item.getKey();

  int sort(LessonInfo item1, LessonInfo item2) {
    return item1.date!.compareTo(item2.date!);
  }
}

class LessonInfosList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;
  LessonInfosList({required this.plannerDatabase});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<LessonInfo>>(
        stream: plannerDatabase.lessoninfos.stream
            .map((data) => data.values.toList()
              ..sort((l1, l2) {
                return l1.date!.compareTo(l2.date!);
              })),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<LessonInfo> list = snapshot.data ?? [];
            return ListView.builder(
              itemBuilder: (context, index) {
                LessonInfo item = list[index];
                Lesson? lesson = item.getLesson(plannerDatabase);
                Course? courseInfo =
                    plannerDatabase.getCourseInfo(item.courseid!);
                return ListTile(
                  onTap: () {
                    pushWidget(
                        context,
                        NewLessonInfoView(
                          plannerDatabase,
                          editmode: true,
                          lessoninfoid: item.id,
                          courseid: item.courseid,
                        ));
                  },
                  leading: ColoredCircleIcon(
                    icon: Icon(
                        getLessonInfoTypes(context)[item.type.index].iconData),
                  ),
                  title: Text(courseInfo?.getName() ?? '???'),
                  subtitle: Column(
                    children: <Widget>[
                      Text(getDateText(item.date!)),
                      Text(lesson != null
                          ? getLessonTitle(context, lesson)
                          : '-'),
                    ],
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  isThreeLine: true,
                );
              },
              itemCount: list.length,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushWidget(context, NewLessonInfoView(plannerDatabase));
        },
        icon: Icon(Icons.add),
        label: Text(getString(context).newlessoninfo),
      ),
    );
  }
}
