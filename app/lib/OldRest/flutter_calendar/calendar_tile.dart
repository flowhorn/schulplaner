import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/OldRest/flutter_calendar/date_utils.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;
  final Widget indicators;

  final Color background;

  CalendarTile(
    this.background, {
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek = false,
    this.isSelected = false,
    this.indicators,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return InkWell(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            dayOfWeek,
            style: dayOfWeekStyles,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onDateSelected,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 6.0,
              child: indicators,
            ),
            Container(
              decoration: isSelected
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      //border: Border.all(width: 4.0, color: Colors.transparent)
                    )
                  : BoxDecoration(),
              alignment: Alignment.center,
              child: Text(
                Utils.formatDay(date).toString(),
                style: isSelected
                    ? TextStyle(
                        color: getTextColor(Theme.of(context).primaryColor),
                        fontWeight: isToday(date) ? FontWeight.bold : null,
                      )
                    : dateStyles,
                textAlign: TextAlign.center,
              ),
              height: 34.0,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return child;
    }
    return Container(
      decoration: BoxDecoration(
        color: background,
      ),
      child: renderDateOrDayOfWeek(context),
    );
  }
}
