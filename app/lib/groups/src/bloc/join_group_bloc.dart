// @dart=2.11
import 'package:bloc/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/Data/Planner/PublicCode.dart';
import 'package:schulplaner8/Helper/helper_views.dart';

class JoinGroupBloc extends BlocBase {
  final _enteredCodeSubject = BehaviorSubject<String>();
  final _publicCodeResultSubject = BehaviorSubject<PublicCode>();

  JoinGroupBloc({String initialCode}) {
    if (initialCode != null) {
      _enteredCodeSubject.add(initialCode);
      _searchPublicCode();
    } else {
      _enteredCodeSubject.add('');
    }
  }

  Stream<String> get enteredCode => _enteredCodeSubject;
  String get enteredCodeValue => _enteredCodeSubject.valueWrapper.value;
  Stream<PublicCode> get publicCodeResult => _publicCodeResultSubject;

  Function(String) get changeEnteredCode => _enteredCodeSubject.add;

  Future<void> submitSearch(BuildContext context) async {
    if (enteredCodeValue == null || enteredCodeValue == '') {
      return;
    }
    final sheet_notifier = ValueNotifier<bool>(null);
    showLoadingStateSheet(context: context, sheetUpdate: sheet_notifier);
    sheet_notifier.value = await _searchPublicCode();
  }

  Future<bool> _searchPublicCode() async {
    final publicCodeValue = await getPublicCodeValue(enteredCodeValue);
    _publicCodeResultSubject.add(publicCodeValue);
    return publicCodeValue != null;
  }

  @override
  void dispose() {}
}
