import 'package:bloc/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/Data/Planner/public_code_functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class JoinGroupBloc extends BlocBase {
  final _enteredCodeSubject = BehaviorSubject<String>.seeded('');
  final _publicCodeResultSubject = BehaviorSubject<PublicCode?>();

  JoinGroupBloc({String? initialCode}) {
    if (initialCode != null) {
      _enteredCodeSubject.add(initialCode);
      _searchPublicCode();
    }
  }

  Stream<String> get enteredCode => _enteredCodeSubject;
  String get enteredCodeValue => _enteredCodeSubject.value;
  Stream<PublicCode?> get publicCodeResult => _publicCodeResultSubject;

  Function(String) get changeEnteredCode => _enteredCodeSubject.add;

  Future<void> submitSearch(BuildContext context) async {
    if (enteredCodeValue == '') {
      return;
    }
    final sheet_notifier = ValueNotifier<bool?>(null);
    showLoadingStateSheet(context: context, sheetUpdate: sheet_notifier);
    sheet_notifier.value = await _searchPublicCode();
  }

  Future<bool> _searchPublicCode() async {
    final publicCodeValue =
        await PublicCodeFunctions.getPublicCodeValue(enteredCodeValue);
    _publicCodeResultSubject.add(publicCodeValue);
    return publicCodeValue != null;
  }

  @override
  void dispose() {}
}
