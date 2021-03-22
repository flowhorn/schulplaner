enum ExportUserDataRequestStatus {
  loading,
  successful,
  error,
}

class ExportUserDataRequestStatusConverter {
  static ExportUserDataRequestStatus fromData(String? data) {
    if (data == 'successful') return ExportUserDataRequestStatus.successful;
    if (data == 'error') return ExportUserDataRequestStatus.error;
    return ExportUserDataRequestStatus.loading;
  }

  static String toData(ExportUserDataRequestStatus status) {
    switch (status) {
      case ExportUserDataRequestStatus.loading:
        return 'loading';
      case ExportUserDataRequestStatus.successful:
        return 'successful';
      case ExportUserDataRequestStatus.error:
        return 'error';
    }
  }
}
