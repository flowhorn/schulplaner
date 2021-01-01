import 'package:app_functions/app_functions.dart';
import 'package:authentification/authentification_blocs.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/AppSettings.dart';
import 'package:schulplaner8/Views/MyProfile.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Library.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Overview.dart';
import 'package:schulplaner8/Views/SchoolPlanner/base/planner_sheet.dart';
import 'package:schulplaner8/app_base/src/blocs/app_logic_controller_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/app_stats_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/user_database_bloc.dart';
import 'package:schulplaner8/dynamic_links/src/bloc/dynamic_link_bloc.dart';
import 'package:schulplaner_functions/schulplaner_functions.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'Views/NavigationActions.dart';
import 'app_base/src/blocs/planner_database_bloc.dart';
import 'app_base/src/blocs/planner_loader_bloc.dart';

class SchulplanerBlocs extends StatelessWidget {
  const SchulplanerBlocs._({
    Key key,
    @required this.child,
    @required this.authProviders,
    @required this.mainProviders,
  }) : super(key: key);

  final Widget child;
  final List<BlocProvider> authProviders;
  final List<BlocProvider> mainProviders;

  factory SchulplanerBlocs.create({
    @required Widget child,
    @required FirebaseAuth firebaseAuth,
    @required DynamicLinksBloc dynamicLinksBloc,
  }) {
    final authentificationBloc =
        AuthentificationBloc(firebaseAuth: firebaseAuth);
    final appSettingsBloc = AppSettingsBloc();
    final userDatabaseBloc = UserDatabaseBloc();
    final plannerLoaderBloc = PlannerLoaderBloc();
    final plannerDatabaseBloc = PlannerDatabaseBloc(appSettingsBloc);
    final appFunctionsBloc = AppFunctionsBloc();
    // authProviders
    final List<BlocProvider> authProviders = [
      BlocProvider<AuthentificationBloc>(
        bloc: authentificationBloc,
      ),
      BlocProvider<SignInBloc>(
        bloc: SignInBloc(firebaseAuth: firebaseAuth),
      ),
      BlocProvider<MyAuthProvidersBloc>(
        bloc: MyAuthProvidersBloc(
          authentificationBloc: authentificationBloc,
          firebaseAuth: firebaseAuth,
        ),
      ),
    ];

    // mainProviders
    final List<BlocProvider> mainProviders = [
      BlocProvider<AppLogicControllerBloc>(
        bloc: AppLogicControllerBloc(
          appSettingsBloc: appSettingsBloc,
          authentificationBloc: authentificationBloc,
          userDatabaseBloc: userDatabaseBloc,
          plannerDatabaseBloc: plannerDatabaseBloc,
          plannerLoaderBloc: plannerLoaderBloc,
          dynamicLinksBloc: dynamicLinksBloc,
        ),
      ),
      BlocProvider<UserDatabaseBloc>(
        bloc: userDatabaseBloc,
      ),
      BlocProvider<PlannerDatabaseBloc>(
        bloc: plannerDatabaseBloc,
      ),
      BlocProvider<PlannerLoaderBloc>(
        bloc: plannerLoaderBloc,
      ),
      BlocProvider<AppSettingsBloc>(
        bloc: appSettingsBloc,
      ),
      BlocProvider<AppStatsBloc>(
        bloc: AppStatsBloc(),
      ),
      BlocProvider<AppFunctionsBloc>(
        bloc: appFunctionsBloc,
      ),
      BlocProvider<SchulplanerFunctionsBloc>(
        bloc: SchulplanerFunctionsBloc(appFunctionsBloc),
      ),
      BlocProvider<NavigationBloc>(
        bloc: NavigationBloc(
          getNavigationActionItem: (int index) {
            final actionsData = appSettingsBloc
                .currentValue.configurationData.navigationactions;
            int getActionNumber(int navigationIndex) {
              if (actionsData.containsKey(navigationIndex)) {
                return actionsData[navigationIndex] ?? navigationIndex;
              } else {
                return navigationIndex;
              }
            }

            final actionNumber = getActionNumber(index);
            return allNavigationActions[actionNumber];
          },
          router: NavigationRouter(
            overviewBuilder: (context) => OverviewView(),
            libraryBuilder: (context) => LibraryView(),
            openAppSettings: (context) =>
                NavigationBloc.of(context).openSubPage(
              builder: (context) => AppSettingsView(),
            ),
            openMyProfilePage: (context) =>
                NavigationBloc.of(context).openSubPage(
              builder: (context) => MyProfile(),
            ),
            openPlannersSheet: (context) async {
              showPlannerSheet(context: context);
            },
          ),
        ),
      ),
      BlocProvider<DrawerBloc>(
        bloc: DrawerBloc(),
      ),
    ];

    return SchulplanerBlocs._(
      child: child,
      authProviders: authProviders,
      mainProviders: mainProviders,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: const ValueKey("SchulplanerBlocs"),
      child: child,
      blocProviders: [
        ...mainProviders,
        ...authProviders,
      ],
    );
  }
}
