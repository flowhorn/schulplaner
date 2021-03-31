import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class GradeSpan {
  final String id, name;
  final String? start, end;
  final bool activated;

  const GradeSpan({
    required this.id,
    required this.start,
    required this.end,
    required this.name,
    required this.activated,
  });

  factory GradeSpan.fromData(Map<String, dynamic> data) {
    return GradeSpan(
      id: data['id'],
      start: data['start'],
      end: data['end'],
      name: data['name'] ?? '-',
      activated: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start,
      'end': end,
      'name': name,
    };
  }

  String getName(BuildContext context) {
    if (id == 'custom') {
      return getString(context).custom;
    } else if (id == 'full') {
      return getString(context).wholetimespan;
    } else {
      return name;
    }
  }

  GradeSpan copyWith({
    String? id,
    String? start,
    String? end,
    String? name,
    bool? activated,
  }) {
    return GradeSpan(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
      activated: activated ?? this.activated,
    );
  }

  String getStartText(BuildContext context) {
    if (start == null) {
      return getString(context).open;
    } else {
      return getDateTextShort2(start!);
    }
  }

  String getEndText(BuildContext context) {
    if (end == null) {
      return getString(context).open;
    } else {
      return getDateTextShort2(end!);
    }
  }
}
