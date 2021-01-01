import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/IntroductionScreen/introduction_screen.dart';
import 'package:schulplaner8/IntroductionScreen/page_view_model.dart';
import 'package:schulplaner8/Views/AppSettings.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Library.dart';
import 'package:schulplaner8/Views/SchoolPlanner/PlannerSettings.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/groups/src/pages/course_list.dart';

import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class SetupView extends StatelessWidget {
  final LoadAllPlannerStatus status;
  const SetupView(this.status);
  @override
  Widget build(BuildContext context) {
    final plannerdata = status.getPlanner();
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    return Scaffold(
      appBar: AppHeaderAdvanced(
        title: Column(
          children: <Widget>[
            Text(
              bothlang(context, de: "Einrichtung", en: "Setup"),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              plannerdata.name ?? "-",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              plannerLoaderBloc
                  .editPlanner(plannerdata.copyWith(setup_done: true));
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                pushWidget(context, AppSettingsView());
              }),
        ],
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: bothlang(context,
                de: "Dein digitaler Schulplaner",
                en: "Your digital school planner"),
            bodytext: bothlang(context,
                de: "Du kannst deinen Schulalltag mit deinen Mitschülern gemeinsam verwalten. So teilt ihr euch die Arbeit beim Eintragen von Hausaufgaben und Terminen. Greife von all deinen Geräten darauf zu.",
                en: "You can manage your school life together with your classmates. You can share homework as well as events and more. Access to it from all your devices."),
            image: const Icon(
              Icons.public,
              size: 96.0,
            ),
          ),
          PageViewModel(
            title: bothlang(context, de: "Schulklasse", en: "Schoolclass"),
            bodytext: bothlang(context,
                de: "Verbinde dich mit deinen Mitschülern und synchronisiere deine Fächer automatisch.",
                en: "Connect with your class mates and sync your courses automatically."),
            body: Card(
              child: ShortSchoolClassView(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  side:
                      BorderSide(color: getDividerColor(context), width: 1.0)),
              elevation: 8.0,
            ),
            isDetailed: true,
          ),
          PageViewModel(
            title: bothlang(context, de: "Fächer", en: "Courses"),
            body: Expanded(
                child: Card(
              clipBehavior: Clip.antiAlias,
              child: CourseList(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  side:
                      BorderSide(color: getDividerColor(context), width: 1.0)),
              elevation: 8.0,
            )),
            isDetailed: true,
          ),
          PageViewModel(
            title: bothlang(context, de: "Einstellungen", en: "Settings"),
            body: Expanded(
                child: Card(
              child: ShortPlannerSettings(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  side:
                      BorderSide(color: getDividerColor(context), width: 1.0)),
              elevation: 8.0,
            )),
            isDetailed: true,
          ),
          PageViewModel(
            title: getString(context).timetable,
            isDetailed: true,
            body: Expanded(
                child: Card(
              clipBehavior: Clip.antiAlias,
              child: TimetableView(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  side:
                      BorderSide(color: getDividerColor(context), width: 1.0)),
              elevation: 8.0,
            )),
          ),
          PageViewModel(
            title: bothlang(context,
                de: "Einrichtung abgeschlossen.", en: "Setup finished."),
            bodytext: bothlang(context,
                de: "Beginne mit der Verwaltung deines Schulplaners.",
                en: "Start managing your school planner."),
            image: const Icon(
              Icons.airplanemode_active,
              size: 96.0,
            ),
            footer: RaisedButton(
              onPressed: () {
                plannerLoaderBloc
                    .editPlanner(plannerdata.copyWith(setup_done: true));
              },
              child:
                  Text(bothlang(context, de: "Auf geht's!", en: "Let's Go!")),
            ),
          ),
        ],
        done: Text(getString(context).done.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w600)),
        skip: Text(
          getString(context).skip,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        onDone: () {
          plannerLoaderBloc.editPlanner(plannerdata.copyWith(setup_done: true));
        },
        showSkipButton: true,
        next: Text(
            bothlang(context, de: "Weiter", en: "Continue").toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
