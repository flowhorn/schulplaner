abstract class AuthProviderType {
  final String firebaseProviderId;
  AuthProviderType(this.firebaseProviderId);
}

class AnonymousAuthProviderType extends AuthProviderType {
  AnonymousAuthProviderType(String firebaseProviderId)
      : super(firebaseProviderId);
}

class EmailAuthProviderType extends AuthProviderType {
  final String? email;
  EmailAuthProviderType({
    required String firebaseProviderId,
    required this.email,
  }) : super(firebaseProviderId);
}

class GoogleAuthProviderType extends AuthProviderType {
  final String? email;
  GoogleAuthProviderType({
    required String firebaseProviderId,
    required this.email,
  }) : super(firebaseProviderId);
}

class AppleAuthProviderType extends AuthProviderType {
  AppleAuthProviderType({
    required String firebaseProviderId,
  }) : super(firebaseProviderId);
}

class OtherAuthProviderType extends AuthProviderType {
  OtherAuthProviderType(String firebaseProviderId) : super(firebaseProviderId);
}

extension AuthProviderListExtensions on List<AuthProviderType> {
  bool containsLinkedProviders() {
    for (final authProvider in this) {
      if (authProvider is EmailAuthProviderType) return true;
      if (authProvider is GoogleAuthProviderType) return true;
      if (authProvider is AppleAuthProviderType) return true;
    }
    return false;
  }

  bool isLinkedWithGoogleSignIn() {
    for (final authProvider in this) {
      if (authProvider is GoogleAuthProviderType) return true;
    }
    return false;
  }

  bool isLinkedWithAppleSignIn() {
    for (final authProvider in this) {
      if (authProvider is AppleAuthProviderType) return true;
    }
    return false;
  }

  bool isLinkedWithEmailSignIn() {
    for (final authProvider in this) {
      if (authProvider is EmailAuthProviderType) return true;
    }
    return false;
  }
}
