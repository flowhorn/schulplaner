import 'package:flutter/services.dart';

const platform = MethodChannel('com.xla.school.widget');

Future<String> getStartArgument() async {
  try {
    String result = await platform.invokeMethod('getstartargument');
    return result;
  } catch (e) {
    print(e);
    return null;
  }
}
