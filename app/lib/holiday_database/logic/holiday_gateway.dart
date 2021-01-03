import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:schulplaner8/holiday_database/models/country.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/holiday_database/models/region.dart';
import 'package:schulplaner8/utils/models/coder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class HolidayGateway {
  final FirebaseFirestore _firestore;
  final HolidayCacheManager holidayCacheManager;

  CollectionReference get _regionsReference => _firestore.collection('Regions');
  CollectionReference _regionsDataReference(String regionID) =>
      _regionsReference.doc(regionID).collection('Data');

  const HolidayGateway(this._firestore, this.holidayCacheManager);

  Stream<List<Region>> getRegions({bool isOfficial, Country country}) {
    var query =
        _regionsReference.orderBy('name').where('published', isEqualTo: true);
    if (isOfficial == true) {
      query = query.where('isOfficial', isEqualTo: true);
    }
    if (country != null) {
      query = query.where('country', isEqualTo: countryToJson(country));
    }
    return query.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((docSnapshot) => RegionConverter.fromJson(docSnapshot.data()))
        .toList());
  }

  Stream<Region> getRegion(String regionID) {
    return _regionsReference.doc(regionID).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return RegionConverter.fromJson(snapshot.data());
      } else {
        return null;
      }
    });
  }

  Future<List<Holiday>> loadHolidays(
    String regionID,
  ) async {
    final cacheValue = await holidayCacheManager.loadCache(regionID: regionID);
    if (cacheValue != null) {
      if (cacheValue.item2 == true) {
        return cacheValue.item1;
      }
    }
    final holidays = await loadHolidaysFromFirestore(regionID);
    if (holidays == null && cacheValue != null) {
      return cacheValue.item1;
    }
    await holidayCacheManager.putIntoCache(regionID: regionID, data: holidays);
    return holidays;
  }

  Future<List<Holiday>> loadHolidaysForceRefresh(
    String regionID,
  ) async {
    final holidays =
        await loadHolidaysFromFirestore(regionID, source: Source.server);
    if (holidays != null) {
      await holidayCacheManager.putIntoCache(
          regionID: regionID, data: holidays);
      return holidays;
    } else {
      return null;
    }
  }

  Future<List<Holiday>> loadHolidaysFromFirestore(String regionID,
      {Source source = Source.serverAndCache}) async {
    final snapshot =
        await _regionsDataReference(regionID).get(GetOptions(source: source));
    final documents = snapshot.docs;
    final holidaysMaps = documents
            .map((queryDocSnapshot) => decodeMap(queryDocSnapshot.data(),
                (key, value) => HolidayConverter.fromJson(value, true)))
            .toList() ??
        [];
    if (holidaysMaps.isEmpty) return [];
    if (holidaysMaps.length == 1) return holidaysMaps[0].values.toList();
    final holidays = holidaysMaps.reduce((map1, map2) => map1..addAll(map2));
    return holidays.values.toList();
  }
}

class HolidayCacheManager {
  static final _key = 'holiday_database:';
  static final _lastRefreshed = 'last_refreshed';

  final ValueNotifier<int> lastRefreshedNotifier = ValueNotifier(null);

  Future<Tuple2<List<Holiday>, bool>> loadCache(
      {@required String regionID}) async {
    final sharedPrefInstance = await SharedPreferences.getInstance();
    final value = sharedPrefInstance.getString(_key + regionID);
    if (value != null) {
      final json = jsonDecode(value);
      final lastRefreshed =
          DateTime.fromMillisecondsSinceEpoch(json[_lastRefreshed]);
      final bool isUpToDate =
          lastRefreshed.isAfter(DateTime.now().subtract(Duration(days: 7)));
      lastRefreshedNotifier.value = lastRefreshed.millisecondsSinceEpoch;
      return Tuple2(
          decodeList(
              json['data'], (value) => HolidayConverter.fromJson(value, true)),
          isUpToDate);
    } else {
      return null;
    }
  }

  Future<bool> putIntoCache(
      {@required String regionID, @required List<Holiday> data}) async {
    final sharedPrefInstance = await SharedPreferences.getInstance();
    final lastRefreshed = DateTime.now().millisecondsSinceEpoch;
    lastRefreshedNotifier.value = lastRefreshed;
    Map<String, dynamic> json = {
      _lastRefreshed: lastRefreshed,
      'data': data.map((it) => HolidayConverter.toJson(it)).toList(),
    };
    return sharedPrefInstance.setString(
      _key + regionID,
      jsonEncode(json),
    );
  }
}
