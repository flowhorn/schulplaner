import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:meta/meta.dart';

class WidgetSettings {
  Map<String, dynamic> appdesign;
  bool multiple_weektypes,
      timetable_useshortname,
      schedule_showlessontime,
      zero_lesson;
  int maxlesson;

  WidgetSettings(
      {this.appdesign,
      this.multiple_weektypes,
      this.timetable_useshortname,
      this.schedule_showlessontime,
      this.maxlesson,
      this.zero_lesson});

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
    this.courselist,
    this.lessonlist,
    this.settings,
    this.periodmap,
    this.teacherslist,
    this.memberid,
    @required this.appSettingsBloc,
  });

  UpdateData.collectData({
    @required PlannerDatabase database,
    @required this.appSettingsBloc,
  }) {
    this.courselist = database.courseinfo.data.values.toList();
    this.lessonlist = database.getLessons().values.toList();
    final appSettingsData = appSettingsBloc.currentValue;
    this.settings = WidgetSettings(
      appdesign: Design(
        id: 'widgetdesign',
        name: 'WidgetDesign',
        primary: appSettingsData.primary,
        accent: appSettingsData.accent,
      ).toWidgetJson()
        ..addAll({
          'darkmode': appSettingsData?.appwidgetsettings?.darkmode ?? false,
          'autodark': false,
        }),
      maxlesson: database.getSettings().maxlessons,
      schedule_showlessontime: database.getSettings().timetable_timemode,
      timetable_useshortname:
          appSettingsData.configurationData.timetablesettings.useshortname,
      multiple_weektypes: database.getSettings().multiple_weektypes,
      zero_lesson: database.getSettings().zero_lesson,
    );

    this.periodmap = database.getSettings().lessontimes;
    this.teacherslist = database.teachers.data;
    this.memberid = database.getMemberId();
  }

  Map<String, Object> toJson() {
    List<Map<String, dynamic>> _internalcourselist = courselist.map((Course c) {
      return c.toPrimitiveJson();
    }).toList();
    List<Map<String, dynamic>> _internallessonlist = lessonlist.map((Lesson l) {
      return l.toPrimitiveJson(
          courselist[courselist.indexWhere((c) => c.id == l.courseid)]);
    }).toList();
    List<Map<String, Object>> _internalperiodlist =
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
