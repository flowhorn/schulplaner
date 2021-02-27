//@dart=2.11
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/ManagePlanner.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

void showPlannerSheet({BuildContext context}) {
  final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
  showSheet(
      context: context,
      child: StreamBuilder<LoadAllPlannerStatus>(
          stream: plannerLoaderBloc.loadAllPlannerStatus,
          builder: (context, snapshot) {
            final loadAllPlannerStatus = snapshot.data;
            if (loadAllPlannerStatus == null) {
              return CircularProgressIndicator();
            }
            final plannerlist = loadAllPlannerStatus.getAllPlanner();
            return Flexible(
                child: SingleChildScrollView(
              child: Column(
                children: plannerlist.map((planner) {
                  return ListTile(
                    leading: Icon(Icons.school),
                    title: Text(planner.name),
                    trailing: planner.id == loadAllPlannerStatus.getPlanner().id
                        ? RButton(
                            text: getString(context).selected,
                            onTap: null,
                            enabled: false,
                            iconData: Icons.done,
                            disabledColor: Colors.green)
                        : null,
                    onTap: () {
                      plannerLoaderBloc.setActivePlanner(planner.id);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ));
          }),
      title: getString(context).myplanners,
      actions: [
        RButton(
            onTap: () {
              Navigator.pop(context);
              pushWidget(context,
                  NewPlannerView(plannerLoaderBloc: plannerLoaderBloc));
            },
            iconData: Icons.add,
            text: getString(context).newplanner),
        RButton(
          onTap: () {
            Navigator.pop(context);
            pushWidget(context, ManagePlannerView());
          },
          iconData: Icons.data_usage,
          text: getString(context).manage,
        )
      ]);
}
