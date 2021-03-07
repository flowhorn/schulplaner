import 'package:bloc/bloc_provider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:schulplaner8/Views/SchoolPlanner/overview/tips_card.dart';
import 'package:schulplaner8/app_base/src/blocs/app_stats_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_stats.dart';
import 'package:schulplaner8/donation/donation_card.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class OverviewTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStatsBloc = BlocProvider.of<AppStatsBloc>(context);
    return StreamBuilder<AppStats>(
        stream: appStatsBloc.appStats,
        initialData: appStatsBloc.currentAppStats,
        builder: (context, snapshot) {
          final appStats = snapshot.data;
          if (appStats == null) return Container();
          return Column(
            children: <Widget>[
              if (showRateCard(appStats)) _RateCard(),
              if (showSocialMediaCard(appStats)) _SocialMediaCard(),
              DonationCard(),
            ],
          );
        });
  }

  bool showSocialMediaCard(AppStats stats) {
    if (stats.hidecard_socialmedia) {
      return false;
    } else {
      if (stats.addedtask >= 5) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool showRateCard(AppStats stats) {
    if (stats.hidecard_rateapp) {
      return false;
    } else {
      if (stats.addedtask >= 3) {
        return true;
      } else {
        return false;
      }
    }
  }
}

AppStats _getAppStats(BuildContext context) =>
    BlocProvider.of<AppStatsBloc>(context).currentAppStats;

void _updateAppStats(BuildContext context, AppStats newstats) {
  BlocProvider.of<AppStatsBloc>(context).updateAppStats(newstats);
}

class _SocialMediaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TipsCard(
      iconData: Icons.stars,
      title: BothLangString(
        de: 'Mehr Infos über Neuerungen',
        en: 'More infos about changes',
      ).getText(context),
      content: Column(
        children: <Widget>[
          Text(
            BothLangString(
              de: 'Mit den letzten Updates gab es viele neue Funktionen und Verbesserungen in der App. Möchtest du mehr über neue Funktionen erfahren oder interessiert dich die Entwicklung der App? Dann kannst du uns gerne folgen😊.',
              en: 'With the latest updates, there have been many features and improvements in the app. Would you like to know more about features or are you interested in developing the app? Then you are welcome to follow us😊.',
            ).getText(context),
          ),
          ListTile(
            leading: Icon(
              CommunityMaterialIcons.instagram,
              color: Colors.pink,
            ),
            title: Text(
              'Instagram (@schulplaner.app)',
              style: TextStyle(
                color: Colors.pink,
              ),
            ),
            onTap: () {
              launch('https://www.instagram.com/schulplaner.app');
            },
          ),
          ListTile(
            leading: Icon(
              CommunityMaterialIcons.twitter,
              color: Colors.lightBlue,
            ),
            title: Text(
              'Twitter (@SchulplanerApp)',
              style: TextStyle(
                color: Colors.lightBlue,
              ),
            ),
            onTap: () {
              launch('https://twitter.com/SchulplanerApp');
            },
          ),
        ],
      ),
      bottom: <Widget>[
        RButton(
            text: getString(context).hide,
            onTap: () {
              final stats = _getAppStats(context).copy();
              stats.hidecard_socialmedia = true;
              _updateAppStats(context, stats);
            })
      ],
    );
  }
}

class _RateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TipsCard(
      iconData: Icons.stars,
      title: BothLangString(
        de: 'Gefällt dir der Schulplaner?',
        en: 'Do you like the school planner?',
      ).getText(context),
      content: Text(BothLangString(
        de: 'Wir würden uns sehr über eine gute Bewertung freuen :)',
        en: 'We would be very happy about a good review :)',
      ).getText(context)),
      bottom: <Widget>[
        RButton(
          text: getString(context).rate_us,
          onTap: () {
            LaunchReview.launch();
          },
        ),
        RButton(
          text: getString(context).hide,
          onTap: () {
            final stats = _getAppStats(context).copy();
            stats.hidecard_rateapp = true;
            _updateAppStats(context, stats);
          },
        ),
      ],
    );
  }
}
