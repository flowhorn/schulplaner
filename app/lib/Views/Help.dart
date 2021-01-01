import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/FAQ.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class HelpView extends StatelessWidget {
  HelpView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).help,
      ),
      backgroundColor: getBackgroundColor(context),
      body: ListView(
        children: <Widget>[
          Card(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              FormSpace(12.0),
              ListTile(
                leading: Icon(CommunityMaterialIcons.discord),
                title: Text("Support-Server"),
                trailing: RButton(
                    text: getString(context).openinbrowser,
                    onTap: () {
                      launch("https://discord.gg/uZyK7Tf");
                    }),
              ),
            ],
          )),
          FormSection(title: "FAQ", child: FAQ_ListView()),
          FormHeader2(bothlang(context,
              de: "Credits: Danke Elias🙏", en: "Credits: Thank you Elias🙏"))
        ],
      ),
    );
  }
}
