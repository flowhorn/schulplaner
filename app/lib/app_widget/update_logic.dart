import 'package:flutter/services.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_widget/UpdateAndroid.dart';

const methodChannel = MethodChannel('com.xla.school.widget');
const methodName = 'updateWidget';

class UpdateAppWidgetLogic {
  void update(
    PlannerDatabase database,
    AppSettingsBloc appSettingsBloc,
  ) {
    final updateData = UpdateData.collectData(
        database: database, appSettingsBloc: appSettingsBloc);
    methodChannel.invokeMethod(methodName, updateData.toJson());
  }
}
