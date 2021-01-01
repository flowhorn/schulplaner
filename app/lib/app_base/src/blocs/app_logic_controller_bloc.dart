import 'package:authentification/authentification_blocs.dart';
import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/Helper/NativeConnection.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/user_database_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/dynamic_links/src/bloc/dynamic_link_bloc.dart';
import 'package:schulplaner8/models/planner.dart';
import 'package:tuple/tuple.dart';
import 'package:universal_commons/platform_check.dart';

class AppLogicControllerBloc extends BlocBase {
  final AuthentificationBloc authentificationBloc;
  final AppSettingsBloc appSettingsBloc;
  final PlannerDatabaseBloc plannerDatabaseBloc;
  final PlannerLoaderBloc plannerLoaderBloc;
  final UserDatabaseBloc userDatabaseBloc;
  final DynamicLinksBloc dynamicLinksBloc;

  String startArgument;

  AppLogicControllerBloc({
    @required this.authentificationBloc,
    @required this.appSettingsBloc,
    @required this.plannerDatabaseBloc,
    @required this.plannerLoaderBloc,
    @required this.userDatabaseBloc,
    @required this.dynamicLinksBloc,
  }) {
    authentificationBloc.authentificationStatus.listen(_updateAuthentification);
    if (PlatformCheck.isAndroid) {
      getStartArgument().then((result) {
        startArgument = result;
      });
    }
    CombineLatestStream.combine2<AuthentificationStatus, LoadAllPlannerStatus,
        Tuple2<UserId, Planner>>(
      authentificationBloc.authentificationStatus,
      plannerLoaderBloc.loadAllPlannerStatus,
      (authentificationStatus, loadAllPlannerStatus) {
        return Tuple2(
            authentificationStatus.userId, loadAllPlannerStatus.getPlanner());
      },
    ).listen((tuple) => _updatePlanner(tuple.item1, tuple.item2));
  }

  void _updateAuthentification(
      AuthentificationStatus newAuthentificationStatus) {
    final userId = newAuthentificationStatus.userId;
    if (userId != null) {
      plannerLoaderBloc.setAuthentification(userId);
      userDatabaseBloc.setAuthentification(userId);
    } else {
      plannerLoaderBloc.clearAuthentification();
      userDatabaseBloc.clearAuthentification();
    }
  }

  void _updatePlanner(UserId userId, Planner planner) {
    plannerDatabaseBloc.setPlanner(userId, planner?.id);
  }

  @override
  void dispose() {}
}
