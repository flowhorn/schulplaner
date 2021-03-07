// @dart=2.11
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/models/planner.dart';

class LoadAllPlannerStatus {
  final String _activePlanner;
  final Map<String, Planner> plannermap;
  final Map<String, int> plannerordermap;
  final bool _loadedData;

  const LoadAllPlannerStatus({
    @required String activePlanner,
    @required Map<String, Planner> plannerlist,
    @required Map<String, int> plannerorder,
    @required bool loadedData,
  })  : _activePlanner = activePlanner,
        plannermap = plannerlist,
        _loadedData = loadedData,
        plannerordermap = plannerorder;

  List<Planner> getAllPlanner() {
    return (plannermap?.values ?? []).toList()
      ..sort((p1, p2) {
        return ((plannerordermap ?? {})[p2.id] ?? -1)
            .compareTo((plannerordermap ?? {})[p1.id] ?? -1);
      });
  }

  Planner getPlanner() {
    if (plannermap.isNotEmpty) {
      if (plannermap.containsKey(_activePlanner)) {
        return plannermap[_activePlanner];
      } else {
        return plannermap.values.first;
      }
    } else {
      return null;
    }
  }

  int getType() {
    if (_loadedData == true) {
      if (getPlanner() == null) {
        return 0;
      } else {
        return 1;
      }
    } else {
      return -1;
    }
  }

  @override
  bool operator ==(other) {
    return other is LoadAllPlannerStatus &&
        (other._activePlanner == _activePlanner &&
            other._loadedData == _loadedData &&
            mapEquals(other.plannerordermap, plannerordermap) &&
            mapEquals(other.plannermap, plannermap));
  }

  @override
  int get hashCode {
    return hashList([_activePlanner, _loadedData, plannerordermap, plannermap]);
  }
}
