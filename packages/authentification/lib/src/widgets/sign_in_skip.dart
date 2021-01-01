import 'package:authentification/src/blocs/sign_in_bloc.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'authentification_login_tile.dart';

class SignInSkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);
    return AuthentificationLoginTile(
      iconData: Icons.skip_next,
      color: getAccentColor(context),
      title: getString(context).skip,
      onTap: () => signInBloc.tryAnonymouslySignIn(),
    );
  }
}
