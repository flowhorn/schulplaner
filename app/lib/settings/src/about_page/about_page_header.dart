import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schulplaner8/Config.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Overview.dart';
import 'package:schulplaner8/Views/settings/pages/settings_changelog_page.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabletMode = MediaQuery.of(context).size.width > 500;
    return Column(
      children: [
        FormSpace(8),
        if (tabletMode)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _Logo(),
              Column(
                children: [
                  FormSpace(4),
                  _AppTitle(),
                  FormSpace(4),
                  _AppVersion(),
                  FormSpace(8.0),
                  _Actions(),
                ],
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ],
          )
        else
          Column(
            children: [
              _Logo(),
              _AppTitle(),
              FormSpace(4),
              _AppVersion(),
              FormSpace(8.0),
              _Actions(),
            ],
          ),
        FormSpace(8),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Icon(
        Icons.school,
        size: 76.0,
        color: getPrimaryColor(context),
      ),
      backgroundColor: getBottomAppBarColor(context),
      radius: 52.0,
    );
  }
}

class _AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      getString(context).apptitle,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 21.0),
    );
  }
}

class _AppVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      getString(context).version +
          ': ${Config.versionName} (${Config.versionCode.toString()})',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    );
  }
}

class _Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormSection(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 12,
            ),
            QuickActionView(
              iconData: Icons.format_list_bulleted,
              text: getString(context).changelog,
              color: Colors.blueAccent,
              onTap: () {
                final navigationBloc = NavigationBloc.of(context);
                navigationBloc.openSubPage(
                    builder: (context) => ChangelogView());
              },
            ),
            SizedBox(
              width:
                  7, /* To have the same spacing as on the right. Probably belongs to the text-length */
            ),
            QuickActionView(
              iconData: Icons.layers_sharp,
              text: getString(context).licenses,
              color: Colors.blueAccent,
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            SizedBox(
              width: 12,
            ),
            QuickActionView(
              iconData: FontAwesomeIcons.github,
              text: getString(context).github,
              color: Colors.blueAccent,
              onTap: () {
                launch('https://github.com/flowhorn/schulplaner');
              },
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
