import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/app_base/src/models/configuration_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsBloc extends BlocBase {
  final _appSettingsDataSubject = BehaviorSubject<AppSettingsData>();

  AppSettingsBloc() {
    _appSettingsDataSubject.add(AppSettingsData.fromString(null));
    _initializeAppSettings();
  }

  Future<void> _initializeAppSettings() async {
    final instance = await SharedPreferences.getInstance();

    final sharedPrefData = instance.getString('appsettings');
    if (sharedPrefData != null) {
      final newData = AppSettingsData.fromString(sharedPrefData);
      if (newData != null) {
        _appSettingsDataSubject.add(newData);
      }
    }
  }

  AppSettingsData get currentValue => _appSettingsDataSubject.value;

  Stream<AppSettingsData> get appSettingsData => _appSettingsDataSubject;

  void setAppConfiguration(ConfigurationData newdata) {
    AppSettingsData newAppdata =
        currentValue.copyWith(configurationData: newdata);
    setAppSettings(newAppdata);
  }

  void setAppSettings(AppSettingsData newData) {
    _appSettingsDataSubject.add(newData);

    SharedPreferences.getInstance().then((instance) {
      String newdatastring = newData.toJsonString();
      if (newdatastring != null) {
        instance.setString('appsettings', newdatastring);
      }
    });
  }

  @override
  void dispose() {
    _appSettingsDataSubject.close();
  }
}

AppSettingsData getAppSettingsData(BuildContext context) =>
    BlocProvider.of<AppSettingsBloc>(context).currentValue;
