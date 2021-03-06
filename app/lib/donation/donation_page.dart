import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:universal_commons/platform_check.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openDonationPage({required BuildContext context}) async {
  await pushWidget(context, _DonationPage());
}

class _DonationPage extends StatelessWidget {
  const _DonationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schulplaner unterstützen'),
      ),
      body: _Body(),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {
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
          FloatingActionButton.extended(
            heroTag: 'fab2',
            onPressed: () {
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
