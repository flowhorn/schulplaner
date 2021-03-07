//@dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

enum CalIndicator { EVENT, TASK, TESTANDEXAM, VACATION, WEEKEND }

class CalValue {
  bool enabled;
  Color color;

  CalValue(this.enabled, this.color);

  CalValue.fromJson(dynamic json) {
    enabled = json['e'];
    color = fromHex(json['c']);
  }

  Map<String, dynamic> toJson() {
    return {
      'e': enabled,
      'c': getHex(color),
    };
  }

  void setColor(Color c) => color = c;

  void setEnabled(bool b) => enabled = b;

  @override
  bool operator ==(other) {
    if (other is CalValue &&
        enabled == other.enabled &&
        getHex(color) == getHex(other.color)) return true;
    return false;
  }
}

class CalendarSettings {
  Map<CalIndicator, CalValue> indicators;
  CalendarSettings({this.indicators}) {
    if (indicators == null) {
      indicators = {
        CalIndicator.EVENT: CalValue(true, Colors.blueGrey),
        CalIndicator.TASK: CalValue(true, Colors.orange),
        CalIndicator.TESTANDEXAM: CalValue(true, Colors.red),
        CalIndicator.VACATION: CalValue(true, Colors.lightGreen),
      };
    }
  }
  CalendarSettings.fromJson(dynamic json) {
    if (json != null) {
      Map<String, dynamic> premap_indicators =
          json['indicators']?.cast<String, dynamic>() ?? {};
      premap_indicators.removeWhere((key, value) => value == null);

      indicators = premap_indicators.map<CalIndicator, CalValue>(
          (String key, value) => MapEntry(CalIndicator.values[int.parse(key)],
              CalValue.fromJson(value?.cast<String, dynamic>())));
    } else {
      indicators = {};
    }

    if (indicators[CalIndicator.EVENT] == null) {
      indicators[CalIndicator.EVENT] = CalValue(true, Colors.blueGrey);
    }
    if (indicators[CalIndicator.WEEKEND] == null) {
      indicators[CalIndicator.WEEKEND] = CalValue(false, Colors.blue);
    }
    if (indicators[CalIndicator.VACATION] == null) {
      indicators[CalIndicator.VACATION] = CalValue(true, Colors.lightGreen);
    }
    if (indicators[CalIndicator.TASK] == null) {
      indicators[CalIndicator.TASK] = CalValue(true, Colors.orange);
    }
    if (indicators[CalIndicator.TESTANDEXAM] == null) {
      indicators[CalIndicator.TESTANDEXAM] = CalValue(true, Colors.red);
    }
  }

  Map<String, Object> toJson() {
    return {
      'indicators': indicators?.map<String, dynamic>((key, value) {
        return MapEntry<String, dynamic>(key.index.toString(), value?.toJson());
      }),
    };
  }

  CalValue getEvent() {
    return indicators[CalIndicator.EVENT] ?? CalValue(true, Colors.blueGrey);
  }

  CalValue getWeekend() {
    return indicators[CalIndicator.WEEKEND] ??
        CalValue(false, Colors.deepOrangeAccent);
  }

  CalValue getVacation() {
    return indicators[CalIndicator.VACATION] ??
        CalValue(true, Colors.lightGreen);
  }

  CalValue getTask() {
    return indicators[CalIndicator.TASK] ?? CalValue(true, Colors.orange);
  }

  CalValue getTestAndExam() {
    return indicators[CalIndicator.TESTANDEXAM] ?? CalValue(true, Colors.red);
  }
}
