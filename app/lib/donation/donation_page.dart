import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/ads/ad_support.dart';
import 'package:schulplaner8/configuration/configuration_bloc.dart';
// import 'package:schulplaner8/ads/get_ad_id.dart';
// import 'package:schulplaner_addons/common/show_toast.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:universal_commons/platform_check.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openDonationPage({required BuildContext context}) async {
  await pushWidget(context, _DonationPage());
}

/*

Future<void> loadRewardAd(BuildContext context) {
  pushWidget(context, _ThankYouPage());
  return RewardedAd.load(
    adUnitId: GetAdId.donationRewardAd,
    request: AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        // Keep a reference to the ad so you can show it later.
        ad.show(onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
          showToastMessage(
            msg: bothlang(context,
                de: 'Danke fürs Unterstützen von Schulplaner!',
                en: 'Thank you for supporting Schoolplanner!'),
          );
        });
      },
      onAdFailedToLoad: (LoadAdError error) {
        showToastMessage(
          msg: bothlang(context, de: 'Fehler!', en: 'Failure!'),
        );
      },
    ),
  );
}

*/
class _ThankYouPage extends StatelessWidget {
  const _ThankYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bothlang(context, de: 'Danke!', en: 'Thanks!'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 64,
                  child: Center(
                    child: Icon(
                      Icons.celebration_outlined,
                      size: 96,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ListTile(
                  title: Text(
                    bothlang(context,
                        de: 'Danke dir für das Unterstützen dieser App. Dies hilf das Projekt am Leben zu halten.',
                        en: 'Thank you for supporting this app!'),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                MaterialButton(
                  color: getAccentColor(context),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        bothlang(context, de: 'Geh zurück', en: 'Go back')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DonationPage extends StatelessWidget {
  const _DonationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schulplaner unterstützen'),
      ),
      body: SingleChildScrollView(child: _Body()),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(BothLangString(
            de: 'Ich habe die Schulplaner App als Schüler in meiner Freizeit entwickelt. Mittlerweile bin ich Student.',
            en: 'I have developed the school planner app as an student in my freetime. Now I am a student at an university.',
          ).getText(context)),
        ),
        ListTile(
          title: Text(BothLangString(
            de: 'Die App macht keine Gewinne, sie ist zu 100% kostenlos. Weder gibt es Werbung, noch kostet irgendetwas hierbei.',
            en: 'The app does not generate any incomes, it is 100% free. Neither are there ads, or something that costs.',
          ).getText(context)),
        ),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.info_outline),
          ),
          title: Text(BothLangString(
            de: 'Doch jeden Monat entstehen Kosten von bis zu 70€ im Monat für die Nutzung der App, welche ich zahlen muss, da mittlerweile über 250.000 Mal die App heruntergeladen haben.',
            en: 'But every month there are costs of up to 70€ for the use of the app, that i have to pay, as more than 250.000 times the app has been downloaded.',
          ).getText(context)),
        ),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.favorite_border_outlined),
          ),
          title: Text(BothLangString(
            de: 'Ich möchte die App kostenlos für alle behalten. Auch ist sie mittlerweile Open-Source, damit jeder mitwirken kann. Ich wäre sehr dankbar für jede Unterstützung, von denen, die unterstützen können und wollen.',
            en: 'I want to keep the app free for all. Also it is open source, so anyone can contribute. I would be very thankful for every support by people who can and want to support.',
          ).getText(context)),
        ),
        SizedBox(height: 32),
        _DonateButton(),
        SizedBox(height: 64),
      ],
    );
  }
}

class _DonateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isIOS) {
      return FloatingActionButton.extended(
        onPressed: () {
          pushWidget(context, _ThankYouPage());
          launch('https://schulplaner.web.app/support');
        },
        label: Text(
          BothLangString(
                  de: 'Mehr auf der Webseite erfahren',
                  en: 'Learn more on the web page')
              .getText(context),
        ),
      );
    } else {
      return Column(
        children: [
          if (!PlatformCheck.isMobile)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  pushWidget(context, _ThankYouPage());
                  launch('https://www.paypal.com/paypalme/felixweuthen');
                },
                label: Text(
                  BothLangString(
                    de: 'Über Paypal spenden',
                    en: 'Donate with paypal',
                  ).getText(context),
                ),
                backgroundColor: Colors.blue,
              ),
            ),
          SizedBox(
            height: 8,
          ),
          // if (AdSupport.areAdsSupported)
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: FloatingActionButton.extended(
          //       heroTag: 'fab3',
          //       onPressed: () {
          //         // loadRewardAd(context);
          //       },
          //       label: Text(
          //         BothLangString(
          //           de: 'Kostenlos eine Werbung schauen',
          //           en: 'Watch one ad for free',
          //         ).getText(context),
          //       ),
          //       backgroundColor: Colors.redAccent,
          //     ),
          //   ),
          SizedBox(
            height: 8,
          ),
          if (ConfigurationBloc.get(context)
                  .detailedNoticeEnabledSubject
                  .value ==
              true)
            FloatingActionButton.extended(
              heroTag: 'fab2',
              onPressed: () {
                pushWidget(context, _ThankYouPage());
                launch('https://schulplaner.web.app/support');
              },
              label: Text(
                BothLangString(
                        de: 'Mehr auf der Webseite erfahren',
                        en: 'Learn more on the web page')
                    .getText(context),
              ),
            ),
        ],
      );
    }
  }
}
