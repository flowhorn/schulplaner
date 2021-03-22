import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

abstract class AppFunctionsException implements Exception {
  String get code;
  String get message;

  @override
  String toString() {
    return 'AppFunctionsException: {Code: $code, Message: $message}';
  }
}

class UnknownAppFunctionsException implements AppFunctionsException {
  final dynamic error;

  const UnknownAppFunctionsException(this.error);

  @override
  String get code => '000';

  @override
  String get message => 'UnknownException: $error';

  @override
  String toString() {
    return message;
  }
}

class TimeoutAppFunctionsException implements AppFunctionsException {
  @override
  String get code => '001';

  @override
  String get message => 'Timeout: Die CloudFunction hat zu lange gebraucht.';
}

class NoInternetAppFunctionsException implements AppFunctionsException {
  @override
  String get code => '002';

  @override
  String get message =>
      'NoInternet: Es konnte keine Internetverbindung hergestellt werden.';
}

AppFunctionsException mapPlatformExceptionToAppFunctionsException(
    PlatformException platformException) {
  if (platformException.code == '-1009')
    return NoInternetAppFunctionsException();
  return UnknownAppFunctionsException(platformException);
}

AppFunctionsException mapCloudFunctionsExceptionToAppFunctionsException(
    FirebaseFunctionsException cloudFunctionsException) {
  if (cloudFunctionsException.code == 'DeadlineExceeded')
    return TimeoutAppFunctionsException();
  print('Code: ' + cloudFunctionsException.code);
  print('Message: ' + (cloudFunctionsException.message ?? '??'));
  return UnknownAppFunctionsException(cloudFunctionsException);
}
