/// Der aktuelle Stand, wie die Anmeldung aussieht. Ob der Anmeldeprozess
/// gerade stattfindet oder fehlgeschlagen ist.
abstract class SignInState {
  static const SignInState none = NoneSignInState();
  static const SignInState loading = LoadingSignInState();
  static const SignInState successfull = SuccessfullSignInState();
  static const SignInState failed = FailedSignInState('');
}

class NoneSignInState implements SignInState {
  const NoneSignInState();
}

class FailedSignInState implements SignInState {
  final String errorMessage;

  const FailedSignInState(this.errorMessage);
}

class LoadingSignInState implements SignInState {
  const LoadingSignInState();
}

class SuccessfullSignInState implements SignInState {
  const SuccessfullSignInState();
}
