import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/Helper/database_foundation.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/models/planner_settings.dart';

class GradeSpanPackage {
  final AppSettingsBloc appSettingsBloc;

  final _currentGradeSpanSubject = BehaviorSubject<GradeSpan>.seeded(
    GradeSpan(
      id: 'full',
      start: null,
      end: null,
      name: 'Gesamter Zeitraum',
      activated: true,
    ),
  );
  final _gradeSpanListSubject = BehaviorSubject<List<GradeSpan>>();

  GradeSpanPackage(
    this.appSettingsBloc,
    DataDocumentPackage<PlannerSettingsData> settingspackage,
  ) {
    _listener = settingspackage.stream.listen((newsettingsdata) {
      _gradeSpanListSubject
          .add(newsettingsdata?.gradespans?.values?.toList() ?? []);
      sortAndSetActivatedCorrectly();
    });
    _listenerappsettings =
        appSettingsBloc.appSettingsData.listen((appSettings) {
      _currentGradeSpanSubject.add(appSettings.gradespan);

      sortAndSetActivatedCorrectly();
    });
  }

  StreamSubscription<PlannerSettingsData> _listener;
  StreamSubscription<AppSettingsData> _listenerappsettings;

  GradeSpan get _current => _currentGradeSpanSubject.value;

  GradeSpan getCurrent(BuildContext context) => _currentGradeSpanSubject.value;

  Stream<GradeSpan> streamcurrent() => _currentGradeSpanSubject;

  Stream<List<GradeSpan>> get streamlist => _gradeSpanListSubject;

  Stream<List<GradeSpan>> get streamlist_full {
    return _gradeSpanListSubject.map(
      (currentList) {
        final fullList = List.of(currentList);
        fullList.insert(
            0,
            GradeSpan(
                id: 'full',
                start: null,
                end: null,
                name: 'Gesamter Zeitraum',
                activated: (_current?.id ?? 'full') == 'full'));
        fullList.insert(
            fullList.length,
            GradeSpan(
                id: 'custom',
                start: null,
                end: null,
                name: 'Benutzerdefiniert',
                activated: _current?.id == 'custom'));
        return fullList;
      },
    );
  }

  void setGradeSpan(GradeSpan newGradeSpan) {
    _currentGradeSpanSubject.add(newGradeSpan);
    appSettingsBloc.setAppSettings(
      appSettingsBloc.currentValue.copyWith(gradespan: newGradeSpan),
    );
    sortAndSetActivatedCorrectly();
  }

  void sortAndSetActivatedCorrectly() {
    final list = _gradeSpanListSubject.value
        .map(
          (gradeSpan) => gradeSpan.copyWith(
            activated: gradeSpan.id == _current?.id,
          ),
        )
        .toList();
    list.sortGradeSpans();
    _gradeSpanListSubject.add(list);
  }

  void close() {
    _listener.cancel();
    _listenerappsettings.cancel();
  }
}

extension on List<GradeSpan> {
  void sortGradeSpans() {
    sort((i1, i2) => (i1.name ?? '').compareTo(i2.name ?? ''));
  }
}
