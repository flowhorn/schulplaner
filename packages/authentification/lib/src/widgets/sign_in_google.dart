import 'package:authentification/src/blocs/sign_in_bloc.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

import 'authentification_login_tile.dart';

class SignInGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);
    return AuthentificationLoginTile(
      iconData: CommunityMaterialIcons.google,
      color: Colors.blue,
      title: "Google",
      onTap: () => signInBloc.tryGoogleSignIn(),
    );
  }
}
