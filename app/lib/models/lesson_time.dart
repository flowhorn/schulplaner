class LessonTime {
  String start, end;
  LessonTime({this.start, this.end});

  LessonTime.fromData(Map<String, dynamic> data) {
    start = data['start'];
    end = data['end'];
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }

  Map<String, dynamic> toWidgetJson(int id) {
    return {
      'id': id,
      'start': start,
      'end': end,
    };
  }

  LessonTime copy() {
    return LessonTime(
      start: start,
      end: end,
    );
  }
}
