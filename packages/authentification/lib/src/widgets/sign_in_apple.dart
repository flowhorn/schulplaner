import 'package:authentification/src/blocs/sign_in_bloc.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInAppleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);
    return FutureBuilder<bool>(
      future: signInBloc.isAppleSignInAvailable(),
      builder: (context, snapshot) {
        final value = snapshot.hasData ? snapshot.data : false;
        if (!value) return Container();
        return SignInWithAppleButton(
          onPressed: () => signInBloc.tryAppleSignIn(),
          style: getBrightness(context) == Brightness.light
              ? SignInWithAppleButtonStyle.black
              : SignInWithAppleButtonStyle.white,
        );
      },
    );
  }
}
