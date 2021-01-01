import 'package:app_functions/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_functions/schulplaner_functions.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

Future<void> tryToLeaveSchoolClass(
    BuildContext context, SchoolClass schoolClass) async {
  final confirmDialog = ConfirmDialog(
      title: getString(context).leave, message: getString(context).leavecourse);
  final confirmResult = await confirmDialog.show<bool>(context);
  if (confirmResult == true) {
    await showAppFunctionStateSheet(
        context, _leaveSchoolClass(context, schoolClass.id));
    Navigator.popUntil(context, (Route predicate) {
      final routeName = predicate?.settings?.name;
      return routeName?.startsWith("schoolclass") == false;
    });
  }
}

Future<AppFunctionsResult<bool>> _leaveSchoolClass(
    BuildContext context, String schoolClassId) {
  final schulplanerFunctions = SchulplanerFunctionsBloc.of(context);
  final plannerDatabase = PlannerDatabaseBloc.getDatabase(context);
  return schulplanerFunctions.leaveGroup(
    groupId: schoolClassId,
    groupType: GroupType.schoolClass,
    myMemberId: plannerDatabase.getMemberId(),
  );
}
