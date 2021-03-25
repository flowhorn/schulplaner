//
import 'dart:async';

import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'calendar_tile.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:schulplaner8/OldRest/flutter_calendar/date_utils.dart';

typedef Widget DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>>? onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder? dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime? initialCalendarDateOverride;

  final PlannerDatabase database;

  Calendar(this.database,
      {this.onDateSelected,
      this.onSelectedRangeChange,
      this.isExpandable = false,
      this.dayBuilder,
      this.showTodayAction = true,
      this.showChevronsToChangeRange = true,
      this.showCalendarPickerIcon = true,
      this.initialCalendarDateOverride});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final calendarUtils = Utils();
  DateTime today = DateTime.now();
  late List<DateTime> selectedMonthsDays;
  late Iterable<DateTime> selectedWeeksDays;
  late DateTime _selectedDate;
  late Tuple2<DateTime, DateTime> selectedRange;
  late String currentMonth;
  bool isExpanded = true;
  late String displayMonth;

  DateTime get selectedDate => _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialCalendarDateOverride != null) {
      today = widget.initialCalendarDateOverride!;
    }
    selectedMonthsDays = Utils.daysInMonth(today);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
    selectedWeeksDays =
        Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
    _selectedDate = today;
    displayMonth = Utils.formatMonth(today);
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showCalendarPickerIcon) {
      rightInnerIcon = IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: Icon(Icons.calendar_today),
      );
    } else {
      rightInnerIcon = Container();
    }

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: Icon(Icons.chevron_left),
        padding: EdgeInsets.all(4.0),
      );
      rightOuterIcon = IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: Icon(Icons.chevron_right),
      );
    } else {
      leftOuterIcon = Container();
      rightOuterIcon = Container();
    }

    if (widget.showTodayAction) {
      leftInnerIcon = InkWell(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child: Text(getString(context).today),
          ),
        ),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftOuterIcon ?? Container(),
        leftInnerIcon ?? Container(),
        Text(
          displayMonth,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        rightInnerIcon ?? Container(),
        rightOuterIcon ?? Container(),
      ],
    );
  }

  Widget get calendarGridView {
    return Container(
      child: GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) =>
            getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          mainAxisSpacing: 0.0,
          padding: EdgeInsets.only(bottom: 0.0),
          children: calendarBuilder(),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
        isExpanded ? selectedMonthsDays : selectedWeeksDays.toList();

    getWeekDays(context).values.forEach(
      (day) {
        dayWidgets.add(
          CalendarTile(
            getBackgroundColor(context),
            isDayOfWeek: true,
            dayOfWeek: day.name.substring(0, 2),
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        dayWidgets.add(
          CalendarTile(getBackgroundColor(context),
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(
                  monthStarted, monthEnded, Theme.of(context).brightness, day),
              isSelected: Utils.isSameDay(selectedDate, day),
              indicators: widget.dayBuilder!(context, day)),
        );
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(
      monthStarted, monthEnded, Brightness brightness, DateTime date) {
    TextStyle dateStyles;
    if (isExpanded) {
      dateStyles = monthStarted && !monthEnded
          ? TextStyle(
              color:
                  brightness == Brightness.light ? Colors.black : Colors.white,
              fontWeight: isToday(date) ? FontWeight.bold : null)
          : TextStyle(
              color: brightness == Brightness.light
                  ? Colors.black38
                  : Colors.white30,
              fontWeight: isToday(date) ? FontWeight.bold : null);
    } else {
      dateStyles = TextStyle(
          color: brightness == Brightness.light ? Colors.black : Colors.white,
          fontWeight: isToday(date) ? FontWeight.bold : null);
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return Container(
        height: 32.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(Utils.fullDayFormat(selectedDate)),
            ),
            IconButton(
              iconSize: 18.0,
              padding: EdgeInsets.all(0.0),
              onPressed: toggleExpanded,
              icon: isExpanded
                  ? Icon(Icons.arrow_drop_up)
                  : Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
          expansionButtonRow
        ],
      ),
    );
  }

  void resetToToday() {
    today = DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);

    setState(() {
      _selectedDate = today;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(today);
    });

    _launchDateSelectionCallback(today);
  }

  void nextMonth() {
    setState(() {
      today = Utils.nextMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(today);
    });
  }

  void previousMonth() {
    setState(() {
      today = Utils.previousMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(today);
    });
  }

  void nextWeek() {
    setState(() {
      today = Utils.nextWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(firstDayOfCurrentWeek);
    });
  }

  void previousWeek() {
    setState(() {
      today = Utils.previousWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(lastDayOfCurrentWeek);
    });
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    selectedRange = Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange!(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays =
            Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = Utils.formatMonth(selected);
      });

      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;
  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(day);
      displayMonth = Utils.formatMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade(
      {required this.collapsed,
      required this.expanded,
      required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
