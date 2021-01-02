import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Views/SchoolPlanner/TimetableFragment.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/planner_settings.dart';

import 'printer.dart';

class PrintTimetable {
  final PlannerDatabase database;

  PrintTimetable(this.database);

  Document buildTimetable() {
    final pdf = Document();
    final settingsData = database.getSettings();
    if (settingsData.multiple_weektypes) {
      for (final int weekType
          in buildIntList(settingsData.weektypes_amount, start: 1)) {
        print(weekType);
        pdf.addPage(Page(
            pageFormat: PdfPageFormat.a4,
            build: (Context context) {
              return TimetablePDFWidget(
                  weekType: weekType,
                  lessons: database.getLessons(),
                  database: database);
            }));
      }
    } else {
      pdf.addPage(Page(
          pageFormat: PdfPageFormat.a4,
          build: (Context context) {
            return TimetablePDFWidget(
                weekType: 0,
                lessons: database.getLessons(),
                database: database);
          }));
    }

    return pdf;
  }

  Future<void> shareTimetable() {
    return Printer().sharePDF(buildTimetable());
  }

  Future<void> printTimetable() {
    return Printer().printPDF(buildTimetable());
  }
}

class TimetablePDFWidget extends StatelessWidget {
  final int weekType;
  final Map<String, Lesson> lessons;
  final PlannerDatabase database;

  TimetablePDFWidget({this.weekType, this.lessons, this.database});

  @override
  Widget build(Context context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (weekType == 1)
            Text("A-Woche", //todo(th3ph4nt0m): remove hard-coded week names
                style: TextStyle(color: PdfColors.black)),
          if (weekType == 2)
            Text("B-Woche", style: TextStyle(color: PdfColors.black)),
          SizedBox(
            height: 40.0,
            child: Row(
              children: <Widget>[
                SizedBox(width: 40.0),
                Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                            database.getSettings().getAmountDaysOfWeek(),
                            (d) => Expanded(
                                  child: Container(
                                      child: Center(
                                        child: Text(weekDays()[d + 1]),
                                      ),
                                      decoration: BoxDecoration(
                                          border: BoxBorder(
                                        left: true,
                                        right: true,
                                        bottom: true,
                                        color: PdfColors.grey600,
                                      ))),
                                ))))
              ],
              mainAxisSize: MainAxisSize.max,
            ),
          ),
          TimetablePDFFragment(
            daysOfWeek: database.getSettings().getAmountDaysOfWeek(),
            events: buildElements(lessons, weekType, database),
            starttime_calendar:
                (database.getSettings().zero_lesson ? 0 : 1).toDouble(),
            endtime_calendar:
                (database.getSettings().maxlessons + 1).toDouble(),
            periods: buildPeriodElements(database),
            lessonheight: 60.0,
          )
        ]);
  }
}

List<String> weekDays() {
  return [
    "Null",
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag",
    "Samstag",
    "Sonntag",
  ]; //todo(th3ph4nt0m): remove hard-coded weekday names
}

List<TimeTableElement> buildElements(
    Map<String, Lesson> datamap, int weektype, PlannerDatabase database) {
  if (datamap == null) return [];
  List<TimeTableElement> mylist = [];

  datamap.values.forEach((l) {
    if (l.correctWeektype(weektype)) {
      mylist.add(TimeTableElement(
        startpos: getStartPositionForFragment(l),
        endpos: getEndPositionForFragment(l),
        course: database.getCourseInfo(l.courseid),
        lesson: l,
      ));
    }
  });
  return mylist;
}

List<TimeTablePeriodElement> buildPeriodElements(PlannerDatabase database) {
  List<TimeTablePeriodElement> mylist = [];
  PlannerSettingsData settingsData = database.settings.data;

  buildIntList(settingsData.maxlessons, start: 1).forEach((period) {
    mylist.add(TimeTablePeriodElement(
        startpos: period.toDouble(),
        endpos: (period + 1).toDouble(),
        period: period));
  });

  return mylist;
}

double getStartPositionForFragment(Lesson lesson) {
  return lesson.start.toDouble();
}

double getEndPositionForFragment(
  Lesson lesson,
) {
  return (lesson.end + 1).toDouble();
}

List<Widget> buildLessons(
    List<Lesson> lessons, int weekType, PlannerDatabase database) {
  List<Widget> widgets = [];
  for (int period in buildIntList(8, start: 1)) {
    widgets.add(WeekDayText(period.toString()));
    for (int day in buildIntList(5, start: 1)) {
      final lesson = lessons.firstWhere((lesson) {
        if (lesson.day == day) {
          return true;
        }
        return false;
      }, orElse: () => null);
      if (lesson != null) {
        widgets.add(
            LessonPdfTile(lesson, database.getCourseInfo(lesson.courseid)));
      } else {
        widgets.add(Container());
      }
    }
  }
  return widgets;
}

class WeekDayText extends StatelessWidget {
  final String text;

  WeekDayText(this.text);
  @override
  Widget build(Context context) {
    return Container(
        child: Center(child: Text(text)),
        decoration: BoxDecoration(
            border: BoxBorder(
          bottom: true,
          top: true,
          color: PdfColors.grey600,
        )));
  }
}

class LessonPdfTile extends StatelessWidget {
  final Lesson lesson;
  final Course course;

  LessonPdfTile(this.lesson, this.course);
  @override
  Widget build(Context context) {
    final place = lesson.place?.name ?? course.getPlaceFirst() ?? "";
    return Container(
      color: PdfColor.fromInt(course.getDesign().primary.value),
      child: Stack(children: [
        Center(
            child: Text(
          course.getName() ?? "/",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
          ),
        )),
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(place, textAlign: TextAlign.center),
                ],
              )),
        ),
      ]),
    );
  }
}

class TimetablePDFFragment extends StatelessWidget {
  double starttime_calendar;
  double endtime_calendar;
  int daysOfWeek;

  List<TimeTableElement> events;
  List<TimeTablePeriodElement> periods;
  double lessonheight;
  TimetablePDFFragment(
      {this.starttime_calendar,
      this.endtime_calendar,
      this.events,
      this.periods,
      this.daysOfWeek,
      this.lessonheight});

  @override
  Widget build(Context context) {
    return SizedBox(
      height: lessonheight * ((endtime_calendar) - starttime_calendar),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40.0,
            child: Stack(
              children: periods.map((period) {
                return Positioned(
                  left: 0.0,
                  top: lessonheight * (period.startpos - starttime_calendar),
                  right: 0.0,
                  child: SizedBox(
                    height: lessonheight * period.duration,
                    child: WeekDayText(period.period.toString()),
                  ),
                );
              }).toList(),
            ),
          )
        ]..addAll(List.generate(daysOfWeek, (d) {
            return Expanded(
              child: Stack(
                children: [
                  ...List.generate(
                      ((endtime_calendar) - starttime_calendar).toInt(),
                      (x) => Positioned(
                          left: 0.0,
                          top: lessonheight * x,
                          right: 0.0,
                          child: Container(
                            height: lessonheight,
                            decoration: BoxDecoration(
                              border: BoxBorder(
                                top: true,
                                bottom: true,
                                left: true,
                                right: true,
                                color: PdfColors.grey600,
                                width: 1.0,
                              ),
                            ),
                          ))),
                  ...events.where((t) => t.lesson.day == (d + 1)).map((t) {
                    double topposition =
                        lessonheight * (t.startpos - starttime_calendar);
                    return Positioned(
                      left: 0.5,
                      top: (topposition <= 0 ? 0 : topposition) + 0.5,
                      right: 0.5,
                      child: SizedBox(
                          height: (topposition <= 0
                                  ? (lessonheight * t.duration + topposition)
                                  : (lessonheight * t.duration)) -
                              1,
                          child: LessonPdfTile(t.lesson, t.course)),
                    );
                  }).toList(),
                ],
              ),
            );
          })),
      ),
    );
  }
}
