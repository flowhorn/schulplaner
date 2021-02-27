import 'package:authentification/authentification_blocs.dart';
import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class EmailAuthProviderTile extends StatelessWidget {
  final EmailAuthProviderType authProviderType;

  const EmailAuthProviderTile({
    Key? key,
    required this.authProviderType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.email,
              color: Colors.red,
            ),
            title: Text(getString(context).linkemail),
            subtitle: Text(
              BothLangString(
                      de: "Melde dich von all deinen Geräten mit deiner Email-Adresse und einem Passwort an",
                      en: "Sign in from all your devices using your email + password")
                  .getText(context),
            ),
          ),
          ListTile(
            leading: Icon(Icons.alternate_email),
            title: Text(authProviderType.email ?? '-'),
            trailing: PopupMenuButton<int>(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text(getString(context).forgotpassword),
                    value: 0,
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  final signInBloc = BlocProvider.of<SignInBloc>(context);
                  await signInBloc.sendPasswordResetRequest(
                      email: authProviderType.email);
                  final infoDialog = InfoDialog(
                    title: getString(context).resetpassword,
                    message: BothLangString(
                      de: "Eine Email an dich wurde versandt.",
                      en: "Email sent.",
                    ).getText(context),
                  );
                  await infoDialog.show(context);
                }
              },
            ),
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
