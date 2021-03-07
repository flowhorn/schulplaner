//@dart = 2.11
import 'dart:async';
import 'dart:math';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';

import '../models/dynamic_link_data.dart';

class DynamicLinksBloc extends BlocBase {
  final FirebaseDynamicLinks dynamicLinks;

  final _dynamicLinksDataSubject =
      BehaviorSubject<Map<String, DynamicLinkData>>();

  Map<String, DynamicLinkData> incomingLinks = {};

  DynamicLinksBloc(this.dynamicLinks) {
    stream().listen((incomingLinkMap) {
      for (final incomingLink in incomingLinkMap.values) {
        print('Incoming Link: ${incomingLink.link.queryParameters}');
      }
    });
  }

  /// Dynamic Link will be catched by the dynamic links pluign. This method
  /// can't be called in the constructor, because otherwise the dynamic link
  /// wouldn't work on ios at a cold start of the app.
  Future<void> initDynamicLinks() async {
    try {
      final initData = await dynamicLinks.getInitialLink();
      addDynamicLinkDataFromFirebase(initData);

      dynamicLinks.onLink(
        onSuccess: (incomingLink) async {
          addDynamicLinkDataFromFirebase(incomingLink);
        },
        onError: (e) async {
          print(
              'DynamicLink Error - Details: ${e.details}, Code: ${e.code}, Message: ${e.message}');
        },
      );
    } catch (e) {
      // print(e);
    }
  }

  void addDynamicLinkDataFromFirebase(PendingDynamicLinkData incominLinkData) {
    if (incominLinkData != null && !_hasLinkBeenProcessed(incominLinkData)) {
      final id = Random().nextInt(999999).toString();
      final data = DynamicLinkData(id: id, link: incominLinkData.link);
      incomingLinks[id] = data;
      _dynamicLinksDataSubject.sink.add(incomingLinks);
    }
  }

  // Diese Methode ist aktuell nur ein Workaround, da aus irgendeinem
  // Grund das Dynamic Link Plugin nicht richtig die Links cleart und
  // dadurch beim erneuten Öffnen der App (wenn die App im Background
  // geöffnet war) der Dynamic Link erneut vom Dynamic Links Plugin
  // getriggert wurde...
  bool _hasLinkBeenProcessed(PendingDynamicLinkData link) {
    var containsMapValue = false;
    incomingLinks.values.forEach((_link) {
      if (_link.link == link.link) containsMapValue = true;
    });
    return containsMapValue;
  }

  Stream<Map<String, DynamicLinkData>> stream() {
    return _dynamicLinksDataSubject;
  }

  /// This function has to be called after using the dynamic link to mark this link
  void setLinkHandled(String id) {
    incomingLinks[id] = incomingLinks[id].copyWith(hasBeenHandled: true);
  }

  @override
  void dispose() {
    dynamicLinks.onLink(onSuccess: null, onError: null);
    _dynamicLinksDataSubject.close();
  }
}

enum DynamicLinksType {
  joinByKey,
  unknown,
}
