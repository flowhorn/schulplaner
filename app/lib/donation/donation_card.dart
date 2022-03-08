import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/SchoolPlanner/overview/tips_card.dart';
import 'package:schulplaner8/ads/ad_support.dart';
import 'package:schulplaner8/app_base/src/blocs/app_stats_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_stats.dart';
import 'package:schulplaner8/donation/donation_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class DonationCard extends StatelessWidget {
  const DonationCard();
  @override
  Widget build(BuildContext context) {
    final appStatsBloc = AppStatsBloc.of(context);
    return StreamBuilder<AppStats>(
        stream: appStatsBloc.appStats,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          final appStats = snapshot.data!;
          if (appStats.shouldHideDonationThisMonth() == false) {
            return TipsCard(
              iconData: CommunityMaterialIcons.heart,
              title: BothLangString(
                de: 'Unterstütze Schulplaner',
                en: 'Support School Planner',
              ).getText(context),
              content: Column(
                children: <Widget>[
                  Text(
                    BothLangString(
                      de: 'Die Schulplaner-App ist zu 100% kostenlos und werbefrei. \n'
                          'Ich habe sie als Schüler in meiner Freizeit entwickelt, doch jeden Monat entstehen Kosten für die Server.',
                      en: 'The school planner app is 100% free and ad-free.\n'
                          'I have developed it in my free time, but every month there are costs for the server.',
                    ).getText(context),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(
                      CommunityMaterialIcons.heart,
                      color: Colors.red,
                    ),
                    title: Text(
                      getString(context).learnmore,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      openDonationPage(context: context);
                    },
                  ),
                  if (AdSupport.areAdsSupported)
                    ListTile(
                      leading: Icon(Icons.play_circle_fill_rounded,
                          color: Colors.greenAccent),
                      title: Text(
                        BothLangString(
                          de: 'Eine Werbeanzeige zum Unterstützen schauen',
                          en: 'Show one ad to support the app',
                        ).getText(context),
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                      onTap: () {
                        // loadRewardAd(context);
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.cancel_outlined),
                    title: Text(
                      BothLangString(
                        de: 'Diesen Monat nicht mehr anzeigen',
                        en: 'Hide for this month',
                      ).getText(context),
                      style: TextStyle(),
                    ),
                    onTap: () {
                      appStatsBloc.hideDonationCardForThisMonth();
                    },
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
