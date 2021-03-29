import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';

class WidgetSettings {
  Map<String, dynamic> appdesign;
  bool multiple_weektypes,
      timetable_useshortname,
      schedule_showlessontime,
      zero_lesson;
  int maxlesson;

  WidgetSettings({
    required this.appdesign,
    required this.multiple_weektypes,
    required this.timetable_useshortname,
    required this.schedule_showlessontime,
    required this.maxlesson,
    required this.zero_lesson,
  });

  Map<String, dynamic> toJson() {
    return {
      'appdesign': appdesign,
      'multiple_weektypes': multiple_weektypes,
      'timetable_useshortname': timetable_useshortname,
      'schedule_showlessontime': schedule_showlessontime,
      'maxlesson': maxlesson,
      'zero_lesson': zero_lesson,
    };
  }
}

class UpdateData {
  List<Course> courselist;
  List<Lesson> lessonlist;
  Map<int, LessonTime> periodmap;
  List<Teacher> teacherslist;
  WidgetSettings settings;
  String memberid;
  final AppSettingsBloc appSettingsBloc;
  UpdateData({
    required this.courselist,
    required this.lessonlist,
    required this.settings,
    required this.periodmap,
    required this.teacherslist,
    required this.memberid,
    required this.appSettingsBloc,
  });

  factory UpdateData.collectData({
    required PlannerDatabase database,
    required AppSettingsBloc appSettingsBloc,
  }) {
    final appSettingsData = appSettingsBloc.currentValue;

    return UpdateData(
      courselist: database.courseinfo.data.values.toList(),
      lessonlist: database.getLessons().values.toList(),
      periodmap: database.getSettings().lessontimes,
      teacherslist: database.teachers.data ?? [],
      memberid: database.getMemberId(),
      settings: WidgetSettings(
        appdesign: Design(
          id: 'widgetdesign',
          name: 'WidgetDesign',
          primary: appSettingsData.primary,
          accent: appSettingsData.accent,
        ).toWidgetJson()
          ..addAll({
            'darkmode': appSettingsData.appwidgetsettings.darkmode,
            'autodark': false,
          }),
        maxlesson: database.getSettings().maxlessons,
        schedule_showlessontime: database.getSettings().timetable_timemode,
        timetable_useshortname:
            appSettingsData.configurationData.timetablesettings.useshortname,
        multiple_weektypes: database.getSettings().multiple_weektypes,
        zero_lesson: database.getSettings().zero_lesson,
      ),
      appSettingsBloc: appSettingsBloc,
    );
  }

  Map<String, Object> toJson() {
    final _internalcourselist =
        courselist.map<Map<String, dynamic>>((Course c) {
      return c.toPrimitiveJson();
    }).toList();
    final _internallessonlist = lessonlist.map<Map<String, dynamic>>((final l) {
      return l.toPrimitiveJson(
          courselist[courselist.indexWhere((c) => c.id == l.courseid)]);
    }).toList();
    List<Map<String, dynamic>> _internalperiodlist =
        periodmap.entries.map((MapEntry<int, LessonTime> entry) {
      return entry.value.toWidgetJson(entry.key);
    }).toList();
    return {
      'courses': _internalcourselist,
      'lessons': _internallessonlist,
      'periods': _internalperiodlist,
      'settings': settings.toJson(),
      'memberid': memberid,
    };
  }
}
