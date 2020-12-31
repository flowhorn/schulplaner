import 'package:authentification/src/models/auth_provider.dart';
import 'package:authentification/src/models/user_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AuthUser {
  const AuthUser({
    @required this.userId,
    @required this.authProviders,
  });
  final UserId userId;
  final List<AuthProviderType> authProviders;

  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(
      userId: UserId(user.uid),
      authProviders: user.providerData.transformToAuthProviderList(),
    );
  }
}

extension on List<UserInfo> {
  List<AuthProviderType> transformToAuthProviderList() {
    return map((userInfo) {
      if (userInfo.providerId == 'apple.com')
        return AppleAuthProviderType(firebaseProviderId: userInfo.providerId);
      if (userInfo.providerId == GoogleAuthProvider.PROVIDER_ID)
        return GoogleAuthProviderType(
          firebaseProviderId: userInfo.providerId,
          email: userInfo.email,
        );
      if (userInfo.providerId == EmailAuthProvider.PROVIDER_ID)
        return EmailAuthProviderType(
          firebaseProviderId: userInfo.providerId,
          email: userInfo.email,
        );

      return OtherAuthProviderType(userInfo.providerId);
    }).toList();
  }
}
