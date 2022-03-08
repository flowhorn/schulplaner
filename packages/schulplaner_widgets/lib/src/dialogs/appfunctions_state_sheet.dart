import 'package:app_functions/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

Future<AppFunctionsResult<bool>> showAppFunctionStateSheet(BuildContext context,
    Future<AppFunctionsResult<bool>> appFunctionsResult) async {
  final stateContentStream = _mapAppFunctionToStateContent(appFunctionsResult);
  final stateSheet = StateSheet(stream: stateContentStream);
  stateSheet.showWithAutoPop(
    context,
    future: appFunctionsResult
        .then((result) => result.hasData && result.data == true),
    delay: Duration(milliseconds: 350),
  );

  return appFunctionsResult.then((value) {
    return Future.delayed(Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<SheetContent> _mapAppFunctionToStateContent(
    Future<AppFunctionsResult<bool>> appFunctionsResult) {
  final _stateContent =
      BehaviorSubject<SheetContent>.seeded(LoadingSheetContent());
  appFunctionsResult.then((result) {
    if (result.hasData) {
      final boolean = result.data;
      if (boolean == true)
        _stateContent.add(successfulSheetContent);
      else
        _stateContent.add(errorSheetContent);
    } else {
      final exception = result.exception;
      if (exception is NoInternetAppFunctionsException)
        _stateContent.add(noInternetSheetContent);
      else
        _stateContent.add(unknownExceptionSheetContent);
    }
  });
  return _stateContent;
}
