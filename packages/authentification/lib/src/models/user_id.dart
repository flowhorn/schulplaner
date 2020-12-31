class UserId {
  const UserId(this.uid);
  final String uid;

  @override
  bool operator ==(other) {
    return other is UserId && other.uid == uid;
  }

  @override
  int get hashCode {
    return uid.hashCode;
  }
}
