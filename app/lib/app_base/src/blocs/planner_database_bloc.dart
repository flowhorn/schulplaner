import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';

class PlannerDatabaseBloc extends BlocBase {
  PlannerDatabaseBloc(this.appSettingsBloc);
  final AppSettingsBloc appSettingsBloc;

  final _currentUserIdSubject = BehaviorSubject<UserId?>();
  UserId? get currentUserId => _currentUserIdSubject.valueOrNull;

  final _currentPlannerIdSubject = BehaviorSubject<String>();
  String? get currentPlannerId => _currentPlannerIdSubject.valueOrNull;

  PlannerDatabase? plannerDatabase;

  void setPlanner(UserId? userId, String? plannerId) {
    // Prevent unnesseccary reloads by checking currentUserId
    if (userId == null || plannerId == null) return;
    if (userId != currentUserId || plannerId != currentPlannerId) {
      plannerDatabase?.onDestroy();
      plannerDatabase = PlannerDatabase(
        uid: userId.uid,
        plannerid: plannerId,
        appSettingsBloc: appSettingsBloc,
      );
      _currentUserIdSubject.add(userId);
      _currentPlannerIdSubject.add(plannerId);
    }
  }

  void clearPlanner() {
    _currentUserIdSubject.add(null);
    plannerDatabase?.onDestroy();
    plannerDatabase = null;
  }

  static PlannerDatabase getDatabase(BuildContext context) {
    return BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
  }

  @override
  void dispose() {
    plannerDatabase?.onDestroy();
    _currentUserIdSubject.close();
  }
}
