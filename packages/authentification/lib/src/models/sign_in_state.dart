/// Der aktuelle Stand, wie die Anmeldung aussieht. Ob der Anmeldeprozess
/// gerade stattfindet oder fehlgeschlagen ist.
enum SignInState {
  none,
  failed,
  loading,
  successfull,
}
