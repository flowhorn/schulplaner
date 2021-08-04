//
import 'dart:async';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/LogAnalytics.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Library.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/base/planner_state.dart';
import 'package:schulplaner8/Views/SchoolPlanner/setup/setup_page.dart';
import 'package:schulplaner8/app_base/src/blocs/app_logic_controller_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/dynamic_links/src/bloc/dynamic_link_bloc.dart';
import 'package:schulplaner8/dynamic_links/src/models/dynamic_link_data.dart';
import 'package:schulplaner8/dynamic_links/src/models/join_by_key.dart';
import 'package:schulplaner8/groups/src/pages/join_group_page.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';

class SchoolPlannerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    final appLogicControllerBloc =
        BlocProvider.of<AppLogicControllerBloc>(context);
    final navigationBloc = NavigationBloc.of(context);
    return StreamBuilder<PlannerSettingsData?>(
        stream: plannerDatabase.settings.stream,
        initialData: plannerDatabase.settings.data,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return MySchoolPlanner(
              plannerDatabase: plannerDatabase,
              plannerSettingsData: snapshot.data!,
              appLogicControllerBloc: appLogicControllerBloc,
              key: ValueKey(plannerDatabase.plannerid),
              navigationBloc: navigationBloc,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MySchoolPlanner extends StatefulWidget {
  final PlannerSettingsData plannerSettingsData;
  final PlannerDatabase plannerDatabase;
  final AppLogicControllerBloc appLogicControllerBloc;
  final NavigationBloc navigationBloc;
  MySchoolPlanner({
    required this.plannerSettingsData,
    required this.plannerDatabase,
    required this.appLogicControllerBloc,
    required this.navigationBloc,
    Key? key,
  }) : super(key: key) {
    print('SchoolPlannerHead Rebuilt!');
    if (appLogicControllerBloc.startArgument != null) {
      if (appLogicControllerBloc.startArgument == 'starttimetable') {
        final newdata = navigationBloc.currentMainPageValue.copy();
        newdata.showSubChild = true;
        newdata.subChild = SlideUp(
          key: Key('Test'),
          child: TimetableView(),
        );
        newdata.subChildName = '';
        newdata.actions = null;
        newdata.index = 4;
        navigationBloc.setMainPage(newdata);
      } else if (appLogicControllerBloc.startArgument == 'starttasks') {
        final newdata = navigationBloc.currentMainPageValue.copy();
        newdata.showSubChild = true;
        newdata.subChild = SlideUp(
          key: Key('Test'),
          child: MyTasksList(),
        );
        newdata.subChildName = '';
        newdata.actions = null;
        newdata.index = 4;
        navigationBloc.setMainPage(newdata);
      }
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _MySchoolPlannerState(
      plannerSettingsData: plannerSettingsData,
      plannerDatabase: plannerDatabase,
    );
  }
}

class _MySchoolPlannerState extends State<MySchoolPlanner>
    with AutomaticKeepAliveClientMixin {
  final PlannerSettingsData plannerSettingsData;
  final PlannerDatabase plannerDatabase;

  late StreamSubscription _streamSubscription;
  _MySchoolPlannerState({
    required this.plannerSettingsData,
    required this.plannerDatabase,
  }) {
    print('SchoolPlannerState Rebuilt!');
  }

  @override
  void initState() {
    super.initState();
    final dynamicLinkLogic = widget.appLogicControllerBloc.dynamicLinksBloc;
    _streamSubscription = dynamicLinkLogic.stream().listen((incomingLinkMap) {
      for (final incomingLink in incomingLinkMap.values) {
        print(
            'Incoming Link in Schulplaner App: ${incomingLink.link.queryParameters}');
        if (_isIncomingLinkTypeJoinByKey(incomingLink)) {
          dynamicLinkLogic.setLinkHandled(incomingLink.id);
          handleJoinByKey(incomingLink.getJoinByKeyData());
        }
      }
    });
  }

  bool _isIncomingLinkTypeJoinByKey(DynamicLinkData incomingLink) {
    return incomingLink != null &&
        incomingLink.hasBeenHandled == false &&
        incomingLink.getType() == DynamicLinksType.joinByKey;
  }

  void handleJoinByKey(DynamicLinkJoinByKey joinByKeyData) {
    LogAnalytics.OpenedJoinLink(joinByKeyData.publicKey);
    openGroupJoinPageByNavigationBloc(
      navigationBloc: widget.navigationBloc,
      initialCode: joinByKeyData.publicKey,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    return WillPopScope(
        child: StreamBuilder<LoadAllPlannerStatus>(
          stream: plannerLoaderBloc.loadAllPlannerStatus,
          initialData: plannerLoaderBloc.loadAllPlannerStatusValue,
          builder: (context, snapshot) {
            final status = snapshot.data;
            if (status?.getPlanner()!.setup_done == false) {
              return SetupView(status!);
            } else {
              final tabletmode = MediaQuery.of(context).size.width > 700;
              if (tabletmode) {
                return TabletUI(
                  plannerStateBuilder: (context) => PlannerState(),
                  libraryTabletWidget: LibraryTabletView(),
                );
              } else {
                return MobileUI(
                  plannerStateBuilder: (context) => PlannerState(),
                );
              }
            }
          },
        ),
        onWillPop: () {
          if (widget.navigationBloc.currentMainPageValue.showSubChild) {
            final newdata = widget.navigationBloc.currentMainPageValue.copy();
            newdata.showSubChild = false;
            newdata.subChild = null;
            newdata.subChildName = null;
            newdata.subChildTag = null;
            widget.navigationBloc.setMainPage(newdata);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        });
  }

  @override
  bool get wantKeepAlive => false;
}
