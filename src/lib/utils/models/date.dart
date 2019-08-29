class Date {
  final String _iso8601String;

  const Date._(this._iso8601String);

  factory Date(String dateString) {
    return Date._(dateString);
  }

  factory Date.fromDateTime(DateTime dateTime) {
    return Date._(dateTime.toIso8601String().substring(0, 10));
  }

  String get toDateString => _iso8601String;
}
