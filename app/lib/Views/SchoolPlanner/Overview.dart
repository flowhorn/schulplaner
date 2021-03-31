//
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/widgets/overview_tips.dart';
import 'package:schulplaner8/Views/widgets/quick_create_view.dart';
import 'package:schulplaner8/app_base/src/blocs/app_stats_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldRest/CalendarView.dart';
import 'package:schulplaner8/OldRest/Timeline.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyLetters.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class OverviewView extends StatelessWidget {
  const OverviewView();

  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    final appStats = AppStatsBloc.of(context);
    appStats.incrementOpenHomePage();
    return SingleChildScrollView(
      child: LimitedContainer(
        child: Column(children: <Widget>[
          QuickCreateView(),
          OverviewTips(),
          StreamBuilder<Map<String, Letter>>(
            builder: (context, snapshot) {
              List<Letter> datalist = snapshot.data?.values.where((letter) {
                    return letter.isRead(plannerDatabase) == false;
                  }).toList() ??
                  [];
              datalist.sort((l1, l2) => l1.published.compareTo(l2.published));
              if (datalist.isNotEmpty) {
                return Column(
                  children: <Widget>[
                    FormHeader2(getString(context).schoolletters),
                    Column(
                      children: datalist.map((letter) {
                        return LetterCard(
                          letter: letter,
                          database: plannerDatabase,
                        );
                      }).toList(),
                    ),
                  ],
                );
              } else {
                return nowidget();
              }
            },
            stream: plannerDatabase.letters.stream.map((datamap) => datamap),
            initialData: plannerDatabase.letters.data,
          ),
          ShortTimelineView(plannerDatabase),
          FormSpace(16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ButtonBar(
              children: <Widget>[
                RButton(
                    text: getString(context).timeline,
                    onTap: () {
                      NavigationBloc.of(context).openSubChild(
                        'timeline',
                        TimelineView(plannerDatabase),
                        getString(context).timeline,
                        navigationItem: NavigationItem.timeline,
                      );
                    },
                    iconData: Icons.timeline),
                RButton(
                    text: getString(context).calendar,
                    onTap: () {
                      NavigationBloc.of(context).openSubChild(
                        'calendar',
                        CalendarView(plannerDatabase),
                        getString(context).calendar,
                        navigationItem: NavigationItem.calendar,
                      );
                    },
                    iconData: Icons.event),
              ],
            ),
          ),
          FormSpace(16.0),
        ]),
      ),
    );
  }
}
