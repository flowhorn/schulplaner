//
import 'package:bloc/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';

class EditApperanceBloc extends BlocBase {
  final _appSettingsDataSubject = BehaviorSubject<AppSettingsData>();
  final AppSettingsBloc appSettingsBloc;
  EditApperanceBloc(this.appSettingsBloc) {
    _appSettingsDataSubject.add(appSettingsBloc.currentValue.copyWith());
  }

  Future<void> submit() async {
    final newValue = _appSettingsDataSubject.valueWrapper!.value;
    appSettingsBloc.setAppSettings(newValue);
  }

  Stream<AppSettingsData> get appSettingsData => _appSettingsDataSubject;

  AppSettingsData get currentValue =>
      _appSettingsDataSubject.valueWrapper!.value;

  void setPrimary(Color primary) {
    _appSettingsDataSubject.add(currentValue.copyWith(primary: primary));
  }

  void setAccent(Color accent) {
    _appSettingsDataSubject.add(currentValue.copyWith(accent: accent));
  }

  void setDarkMode(bool isDarkMode) {
    _appSettingsDataSubject.add(currentValue.copyWith(darkmode: isDarkMode));
  }

  void setAutoDark(bool isAutoDark) {
    _appSettingsDataSubject.add(currentValue.copyWith(autodark: isAutoDark));
  }

  void setColoredAppBar(bool isColoredAppBar) {
    _appSettingsDataSubject
        .add(currentValue.copyWith(coloredAppBar: isColoredAppBar));
  }

  @override
  void dispose() {
    _appSettingsDataSubject.close();
  }
}
