import 'package:authentification/authentification_blocs.dart';
import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'AppState.dart';
import 'SchoolPlanner/MySchoolPlanner.dart';
import 'authentification/login_page.dart';

class HomeOfApp extends StatelessWidget {
  HomeOfApp();
  @override
  Widget build(BuildContext context) {
    final authentificationBloc = BlocProvider.of<AuthentificationBloc>(context);
    return StreamBuilder<AuthentificationStatus>(
      stream: authentificationBloc.authentificationStatus,
      initialData: authentificationBloc.authentificationStatusValue,
      builder: (context, authentificationSnapshot) {
        final authentificationStatus = authentificationSnapshot.data;
        // Nutzer ist authentifiziert
        if (authentificationStatus is AuthentifiedAuthentificationStatus) {
          return HomeOfSchoolPlanner();
        }

        // Nutzer ist nicht authentifiziert
        if (authentificationStatus is NotLoggedInAuthentificationStatus) {
          return LoginPage();
        }

        // Ladebildschirm
        return LoadAppView();
      },
    );
  }
}

class HomeOfSchoolPlanner extends StatelessWidget {
  HomeOfSchoolPlanner();
  @override
  Widget build(BuildContext context) {
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    final plannerDatabaseBloc = BlocProvider.of<PlannerDatabaseBloc>(context);
    return StreamBuilder<LoadAllPlannerStatus>(
      stream: plannerLoaderBloc.loadAllPlannerStatus,
      builder: (context, snapshot) {
        final loadAllPlannerStatus = snapshot.data;
        if (loadAllPlannerStatus?.getPlanner() == null) {
          if (loadAllPlannerStatus?.getType() != -1) {
            return SelectPlannerView(
              key: Key(
                loadAllPlannerStatus.hashCode.toString(),
              ),
            );
          }
          return LoadAppView();
        }

        if (plannerDatabaseBloc.plannerDatabase == null) {
          return LoadAppView();
        } else {
          return SchoolPlannerLoader();
        }
      },
    );
  }
}
