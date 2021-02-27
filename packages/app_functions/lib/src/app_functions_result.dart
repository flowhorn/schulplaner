import 'app_functions_exception.dart';

class AppFunctionsResult<T> {
  final T? data;
  final AppFunctionsException? exception;
  final bool hasData;
  final bool hasException;

  const AppFunctionsResult._({
    this.data,
    this.exception,
    required this.hasData,
    required this.hasException,
  });

  factory AppFunctionsResult.data(T data) {
    return AppFunctionsResult._(
      data: data,
      hasData: true,
      exception: null,
      hasException: false,
    );
  }

  factory AppFunctionsResult.exception(
      AppFunctionsException appFunctionsException) {
    return AppFunctionsResult._(
      data: null,
      hasData: false,
      exception: appFunctionsException,
      hasException: true,
    );
  }
}
