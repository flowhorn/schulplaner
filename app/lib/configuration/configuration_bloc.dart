import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationBloc extends BlocBase {
  final _isSignInPossibleSubject = BehaviorSubject<bool>.seeded(true);
  final _showSignInNoticeSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isSignInPossibleStream => _isSignInPossibleSubject;
  bool get isSignInPossibleValue => _isSignInPossibleSubject.value;

  Stream<bool> get showSignInNoticeStream => _showSignInNoticeSubject;
  bool get showSignInNoticeValue => _showSignInNoticeSubject.value;

  final hideSignInNoticeSubject = BehaviorSubject<bool>.seeded(false);
  final detailedNoticeEnabledSubject = BehaviorSubject<bool>.seeded(true);
  ConfigurationBloc() {
    _init();
  }

  static ConfigurationBloc get(BuildContext context) =>
      BlocProvider.of<ConfigurationBloc>(context);

  void _init() async {
    final instance = FirebaseRemoteConfig.instance;
    await instance.setDefaults({
      'is_sign_in_possible': true,
      'show_sign_in_notice': false,
      'detailed_notice_enabled': false,
    });
    await instance.fetchAndActivate();
    final configs = instance.getAll();
    _isSignInPossibleSubject.add(
      configs['is_sign_in_possible']!.asBool(),
    );
    _showSignInNoticeSubject.add(
      configs['show_sign_in_notice']!.asBool(),
    );
    detailedNoticeEnabledSubject.add(
      configs['detailed_notice_enabled']!.asBool(),
    );
    final sharedPrefInstance = await SharedPreferences.getInstance();
    hideSignInNoticeSubject
        .add(sharedPrefInstance.getBool('hide_sign_in_notice') ?? false);
  }

  void hideSignInNotice() async {
    hideSignInNoticeSubject.add(true);
    final sharedPrefInstance = await SharedPreferences.getInstance();
    await sharedPrefInstance.setBool('hide_sign_in_notice', true);
  }

  @override
  void dispose() {
    _isSignInPossibleSubject.close();
    _showSignInNoticeSubject.close();
    hideSignInNoticeSubject.close();
  }
}
