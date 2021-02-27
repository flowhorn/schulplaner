import 'package:bloc/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class EditDesignBloc extends BlocBase {
  final _designSubject = BehaviorSubject<Design>();
  final _editModeSubject = BehaviorSubject<bool>();
  final _hasChangedValuesSubject = BehaviorSubject<bool>.seeded(false);

  EditDesignBloc() {
    _designSubject.add(Design(
      primary: Colors.green,
      name: '',
    ));
    _editModeSubject.add(false);
  }

  Stream<Design> get design => _designSubject;
  Design get currentDesign => _designSubject.value;
  bool get hasChangedValues => _hasChangedValuesSubject.value;
  bool get isEditMode => _editModeSubject.value;

  void changeName(String name) {
    _designSubject.add(currentDesign.copyWith(name: name));
  }

  void changePrimary(Color primary) {
    _designSubject.add(currentDesign.copyWith(primary: primary));
  }

  void changeAccent(Color accent) {
    _designSubject.add(currentDesign.copyWith(accent: accent));
  }

  @override
  void dispose() {
    _designSubject.close();
    _editModeSubject.close();
    _hasChangedValuesSubject.close();
  }
}
