import 'package:flutter/material.dart';
import 'package:schulplaner_addons/utils/color_utils.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class LessonItemTimeline extends StatelessWidget {
  final int start, end;
  final Color color;
  final String courseName;
  final VoidCallback onTap, onLongPress;
  final LessonInfoType lessonInfoType;

  const LessonItemTimeline(
      {Key key,
      this.start,
      this.end,
      this.color,
      this.courseName,
      this.onTap,
      this.lessonInfoType,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      child: Container(
        width: 55.0,
        height: 55 * 1.618,
        decoration: lessonInfoType == null
            ? BoxDecoration(
                border: Border.all(
                  color: ColorUtils.of(context)
                      .getClearBorderColor(context, color),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(32.0))
            : BoxDecoration(
                color: getLessonInfoColor(lessonInfoType),
                border: Border.all(
                  color: getLessonInfoColor(lessonInfoType),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(32.0)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(32.0),
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      start == end ? start.toString() : '$start-$end',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 47.0,
                      width: 47.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          width: 2.0,
                          color: ColorUtils.of(context)
                              .getClearBorderColor(context, color),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          toShortNameLength(context, courseName),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: getTextColor(color),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
