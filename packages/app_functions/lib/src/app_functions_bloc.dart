import 'package:bloc/bloc_base.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'app_functions_region.dart';
import 'app_functions_exception.dart';
import 'app_functions_result.dart';

class AppFunctionsBloc extends BlocBase {
  const AppFunctionsBloc();

  Future<AppFunctionsResult<T>> callCloudFunction<T>({
    required String functionName,
    required AppFunctionsRegion region,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final cloudFunctions =
          FirebaseFunctions.instanceFor(region: region.regionName);
      final httpsCallable = cloudFunctions.httpsCallable(functionName);
      final httpsCallableResult = await httpsCallable.call(parameters);
      return AppFunctionsResult<T>.data(httpsCallableResult.data);
    } catch (exception) {
      if (exception is PlatformException) {
        return AppFunctionsResult.exception(
            mapPlatformExceptionToAppFunctionsException(exception));
      }
      if (exception is FirebaseFunctionsException) {
        return AppFunctionsResult.exception(
            mapCloudFunctionsExceptionToAppFunctionsException(exception));
      }
      return AppFunctionsResult.exception(
          UnknownAppFunctionsException(exception));
    }
  }

  @override
  void dispose() {}
}
