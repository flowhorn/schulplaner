import 'dart:async';

import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/Helper/References.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/models/planner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlannerLoaderBloc extends BlocBase {
  final _currentUserIdSubject = BehaviorSubject<UserId?>();
  final _plannerMapSubject = BehaviorSubject<Map<String, Planner>>();
  final _plannerOrderSubject = BehaviorSubject<Map<String, int>>();
  final _activePlannerSubject = BehaviorSubject<String?>();
  final _hasLoadedDataSubject = BehaviorSubject<bool>();

  final List<StreamSubscription> _streamSubscriptions = [];

  PlannerLoaderBloc() {
    _setInitalSubjectValues();
  }

  void _setInitalSubjectValues() {
    _hasLoadedDataSubject.add(false);
    _activePlannerSubject.add(null);
    _plannerOrderSubject.add({});
    _plannerMapSubject.add({});
    SharedPreferences.getInstance().then((instance) {
      var activePlanner = instance.getString('activeplanner') ?? 'default';
      if (activePlanner == 'DEFAULT') activePlanner = 'default';
      _activePlannerSubject.add(activePlanner);
    });
  }

  void setAuthentification(UserId userId) {
    // Prevent unnesseccary reloads by checking currentUserId
    if (currentUserId != userId) {
      _currentUserIdSubject.add(userId);
      _setInitalSubjectValues();
      _streamSubscriptions.addAll(
        [
          getPlannerOrderRef(userId).snapshots().listen((snapshot) {
            if (snapshot.data() != null) {
              final plannerOrder = snapshot.data()?.cast<String, int>();
              _plannerOrderSubject.add(plannerOrder ?? {});
            }
          }),
          getPlannerRef(userId)
              .where('deleted', isEqualTo: false)
              .where('archived', isEqualTo: false)
              .snapshots()
              .listen((snapshot) {
            _hasLoadedDataSubject.add(true);
            final plannerMap = (snapshot.docs.asMap().map<String, Planner>(
              (_, snapshot) {
                final mPlanner = Planner.fromData(snapshot.data());
                return MapEntry(mPlanner.id, mPlanner);
              },
            ));
            _plannerMapSubject.add(plannerMap);
          }),
        ],
      );
    }
  }

  void clearAuthentification() {
    _currentUserIdSubject.add(null);
    _clearStreamSubscriptions();
    _setInitalSubjectValues();
  }

  Stream<LoadAllPlannerStatus> get loadAllPlannerStatus {
    final streamCombiner = CombineLatestStream.combine4(
      _plannerMapSubject,
      _plannerOrderSubject,
      _activePlannerSubject,
      _hasLoadedDataSubject,
      (Map<String, Planner> plannerMap, Map<String, int>? plannerOrder,
          String? activePlanner, bool hasLoaded) {
        return LoadAllPlannerStatus(
          activePlanner: activePlanner,
          plannerlist: plannerMap,
          plannerorder: plannerOrder,
          loadedData: hasLoaded,
        );
      },
    );
    return streamCombiner.distinct((status1, status2) => status1 == status2);
  }

  LoadAllPlannerStatus get loadAllPlannerStatusValue {
    return LoadAllPlannerStatus(
      activePlanner: _activePlannerSubject.value,
      plannerlist: _plannerMapSubject.value,
      plannerorder: _plannerOrderSubject.value,
      loadedData: _hasLoadedDataSubject.value,
    );
  }

  UserId? get currentUserId => _currentUserIdSubject.value;
  String? get currentActivePlannerId => _activePlannerSubject.value;

  void setActivePlanner(String plannerId) {
    if (currentActivePlannerId != plannerId) {
      _activePlannerSubject.add(plannerId);
    }
    SharedPreferences.getInstance().then((instance) {
      instance.setString('activeplanner', plannerId);
    });
  }

  void setNewPlannerOrder(Map<String, int> neworder) {
    getPlannerOrderRef(currentUserId!).set(neworder);
  }

  void createPlanner(Planner planner) {
    getPlannerRef(currentUserId!).doc(planner.id).set(
          planner.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void editPlanner(Planner planner) {
    getPlannerRef(currentUserId!).doc(planner.id).set(
          planner.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void archivePlanner(Planner planner, bool archive) {
    getPlannerRef(currentUserId!).doc(planner.id).set(
      {'archived': archive},
      SetOptions(
        merge: true,
      ),
    );
  }

  void createCopy(Planner planner) {
    final plannerID = getPlannerRef(currentUserId!).doc().id;
    final copyPlanner =
        planner.copyWith(id: plannerID, name: '(2)' + planner.name);
    getPlannerRef(currentUserId!).doc(copyPlanner.id).set(
          copyPlanner.toJson(),
          SetOptions(
            merge: true,
          ),
        );
    getPlannerRef(currentUserId!)
        .doc(planner.id)
        .collection('data')
        .doc('settings')
        .get()
        .then((result) {
      getPlannerRef(currentUserId!)
          .doc(copyPlanner.id)
          .collection('data')
          .doc('settings')
          .set(result.data()!);
    });
  }

  void deletePlanner(Planner planner) {
    getPlannerRef(currentUserId!).doc(planner.id).set(
      {'deleted': true},
      SetOptions(
        merge: true,
      ),
    );
  }

  @override
  void dispose() {
    _currentUserIdSubject.close();
    _plannerOrderSubject.close();
    _plannerMapSubject.close();
    _activePlannerSubject.close();
    _hasLoadedDataSubject.close();
    _clearStreamSubscriptions();
  }

  void _clearStreamSubscriptions() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
  }
}
