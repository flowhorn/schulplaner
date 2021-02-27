import 'package:authentification/authentification_models.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class GoogleAuthProviderTile extends StatelessWidget {
  final GoogleAuthProviderType authProviderType;

  const GoogleAuthProviderTile({
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
              CommunityMaterialIcons.google,
              color: Colors.blue,
            ),
            title: Text(
              BothLangString(
                de: "Google-Verknüpfung",
                en: "Google-Link",
              ).getText(context),
            ),
            subtitle: Text(
              BothLangString(
                de: "Melde dich von all deinen Geräten mit deinem Google-Konto an",
                en: "Sign in from all your devices using your Google account",
              ).getText(context),
            ),
          ),
          ListTile(
            leading: Icon(Icons.alternate_email),
            title: Text(authProviderType.email ?? '-'),
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
