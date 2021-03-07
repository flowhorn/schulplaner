import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/SchoolPlanner/base/planner_sheet.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';

class PlannerState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            StreamBuilder<LoadAllPlannerStatus>(
              stream: plannerLoaderBloc.loadAllPlannerStatus,
              builder: (context, snapshot) {
                final planner = snapshot.data?.getPlanner();
                return Text(
                  planner?.name ?? '-',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                );
              },
            ),
            SizedBox(
              width: 8.0,
            ),
            Icon(
              Icons.expand_more,
              size: 24.0,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      onTap: () {
        showPlannerSheet(context: context);
      },
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    );
  }
}
