import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/groups/src/models/course.dart';

Color getRandomColor() {
  Random r = Random();
  List c = [
    Colors.grey,
    Colors.green,
    Colors.blue,
    Colors.redAccent,
    Colors.yellow,
    Colors.white,
    Colors.deepPurpleAccent,
    Colors.amber
  ];
  int count = r.nextInt(c.length);
  return c[count];
}

List<String> buildList(int count) {
  List<String> x = [];
  for (var i = 1; i <= count; i++) {
    x.add(i.toString());
  }
  return x;
}

class TimeTableElement {
  double startpos, endpos;
  Lesson lesson;
  Course course;

  TimeTableElement({this.startpos, this.endpos, this.lesson, this.course});

  double get duration {
    return endpos - startpos;
  }
}

class TimeTablePeriodElement {
  double startpos, endpos;
  LessonTime lessonTime;
  int period;

  TimeTablePeriodElement(
      {this.startpos, this.endpos, this.lessonTime, this.period});

  double get duration {
    return endpos - startpos;
  }
}

class Weekview_LeftPanel_Lesson extends StatelessWidget {
  final int period;
  final double hourHeight;

  Weekview_LeftPanel_Lesson(this.period, {this.hourHeight});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 35.0,
        padding: EdgeInsets.all(1.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            period.toString() + '. ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        height: hourHeight,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[600], width: 0.2)),
      ),
    );
  }
}

class Weekview_LeftPanel_LessonTime extends StatelessWidget {
  final LessonTime lessonTime;
  final double hourHeight;

  Weekview_LeftPanel_LessonTime(this.lessonTime, {this.hourHeight});

  @override
  Widget build(BuildContext context) {
    if (lessonTime?.start == null || lessonTime?.end == null) {
      return Container();
    }
    return Material(
      child: Container(
        width: 45.0,
        padding: EdgeInsets.all(1.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            lessonTime.start + '\n-\n' + lessonTime.end,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        height: hourHeight,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[600], width: 0.2)),
      ),
    );
  }
}

class WeekView_LessonView extends StatelessWidget {
  final Lesson item;
  final Course course;
  final VoidCallback onTap;

  WeekView_LessonView(this.item, this.course, this.onTap);

  @override
  Widget build(BuildContext context) {
    Color color = course.getDesign().primary;
    return Container(
      margin: EdgeInsets.only(left: 1.5, right: 1.5, top: 1.5, bottom: 1.5),
      child: Material(
        color: color,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 2.0, right: 2.0),
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  use_shortname(context)
                      ? (course.getShortname_full())
                      : (course.getName()),
                  style: TextStyle(
                    color: getTextColor(color),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  textAlign:
                      center_text(context) ? TextAlign.center : TextAlign.start,
                  minFontSize: 8.0,
                  maxFontSize: 13.6,
                  stepGranularity: 0.1,
                ),
                Text(
                  item.place?.name ?? course.getPlaceFirst() ?? '-',
                  maxLines: 1,
                  style: TextStyle(
                      color: getTextColor(course.getDesign().primary),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300),
                  textAlign:
                      center_text(context) ? TextAlign.center : TextAlign.start,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: center_text(context)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
            ),
          ),
          onTap: onTap,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: getVeryEventualBorder(context, color),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
    );
  }
}

class TimetableFragment extends StatelessWidget {
  final double starttime_calendar;
  final double endtime_calendar;
  final int daysOfWeek;
  final bool timemode, haszerolesson;
  final ValueSetter<Lesson> onTapLesson;
  final ValueSetter<TwoObjects<int, int>> onTapEmpty;
  final List<TimeTableElement> events;
  final List<TimeTablePeriodElement> periods;
  final double lessonheight;
  const TimetableFragment(
      {this.starttime_calendar = 0,
      this.endtime_calendar = 24,
      this.events,
      this.haszerolesson,
      this.onTapEmpty,
      this.periods,
      this.onTapLesson,
      this.timemode,
      this.daysOfWeek,
      this.lessonheight = 60.0});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          delegate: WeekViewHeaderDelegate(daysOfWeek),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: lessonheight * ((endtime_calendar) - starttime_calendar),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: timemode ? 45.0 : 35.0,
                  child: Stack(
                    children: periods.map((period) {
                      return Positioned(
                        left: 0.0,
                        top: lessonheight *
                            (period.startpos - starttime_calendar),
                        right: 0.0,
                        height: lessonheight * period.duration,
                        child: timemode
                            ? Weekview_LeftPanel_LessonTime(period.lessonTime)
                            : Weekview_LeftPanel_Lesson(period.period),
                      );
                    }).toList(),
                  ),
                ),
                ...List.generate(daysOfWeek, (d) {
                  return Expanded(
                    child: Stack(
                      children: List.generate(
                          (((endtime_calendar) - starttime_calendar)
                                  .toInt()
                                  ?.abs() ??
                              12),
                          (x) => Positioned(
                                left: 0.0,
                                top: lessonheight * x,
                                right: 0.0,
                                height: lessonheight,
                                child: InkWell(
                                  child: Container(
                                    decoration: show_grid(context)
                                        ? BoxDecoration(
                                            border: Border.all(
                                                color: getDividerColor(context),
                                                width: 0.1))
                                        : null,
                                  ),
                                  onTap: timemode
                                      ? null
                                      : () {
                                          onTapEmpty(TwoObjects(
                                              item: (d + 1),
                                              item2:
                                                  haszerolesson ? x : (x + 1)));
                                        },
                                ),
                              ))
                        ..addAll(events
                            .where((t) => t.lesson.day == (d + 1))
                            .map((t) {
                          double topposition =
                              lessonheight * (t.startpos - starttime_calendar);
                          return Positioned(
                            left: 0.0,
                            top: topposition <= 0 ? 0 : topposition,
                            right: 0.0,
                            height: topposition <= 0
                                ? (lessonheight * t.duration + topposition)
                                : (lessonheight * t.duration),
                            child: WeekView_LessonView(t.lesson, t.course, () {
                              onTapLesson(t.lesson);
                            }),
                          );
                        })),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WeekViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  int daysOfWeek;

  WeekViewHeaderDelegate(this.daysOfWeek);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: Container(
        child: Row(
          children: <Widget>[
            SizedBox(width: 40.0),
            Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        daysOfWeek,
                        (d) => Expanded(
                              child: Center(
                                child: Text(getListOfWeekDaysFull(context)[d]
                                    .name
                                    .substring(0, 2)),
                              ),
                            ))))
          ],
          mainAxisSize: MainAxisSize.max,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

//CONFIGS::

bool use_shortname(context) =>
    getConfigurationData(context).timetablesettings.useshortname;
bool center_text(context) =>
    getConfigurationData(context).timetablesettings.centertext;
bool show_grid(context) =>
    getConfigurationData(context).timetablesettings.showgrid;
