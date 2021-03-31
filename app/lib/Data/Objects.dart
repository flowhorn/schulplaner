class TwoObjects<T, T2> {
  T item;
  T2 item2;
  TwoObjects({required this.item, required this.item2});
}

class ThreeObjects<T, T2, T3> {
  T item;
  T2 item2;
  T3 item3;
  ThreeObjects({required this.item, required this.item2, required this.item3});
}

class CalendarIndicator {
  bool? enabled;
}

class PersonalType {}

class WeekTypeFixPoint {
  late String date;
  late int weektype;
  WeekTypeFixPoint({required this.date, required this.weektype});

  WeekTypeFixPoint.fromData(Map<String, dynamic>? data) {
    if (data != null) {
      date = data['date'];
      weektype = data['weektype'];
    } else {
      date = '2021-01-01';
      weektype = 1;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weektype': weektype,
    };
  }
}
