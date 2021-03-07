import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';
import 'package:schulplaner_website/src/widgets/information_card.dart';

class InformationCards extends StatelessWidget {
  const InformationCards();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSides(
      first: Column(
        children: const [
          InformationCard(
            title: 'Intelligent',
            description:
                'Jetzt geht alles noch viel einfacher und schneller. Denn durch Features wie die Ermittlung deiner nächsten Stunde, wirst du hilfreich unterstützt.',
          ),
          InformationCard(
            title: 'Vernetzt',
            description:
                'Verbinde dich mit deinen Freunden und Mitschülern. So könnt ihr gemeinsam den Schulalltag meistern. Nur noch einer muss die Hausaufgaben und den Stundenplan eintragen. Und alle erhalten sind immer auf dem neuesten Stand.',
          ),
        ],
      ),
      second: Column(
        children: const [
          InformationCard(
            title: 'Übersichtlich',
            description:
                'Habe alles wichtige immer auf einem Blick. So wirst du nie wieder etwas wichtiges vergessen.',
          ),
          InformationCard(
            title: 'Sicher',
            description:
                'Wir verwenden neueste und beste Technologien für die App. So ist die gesamte App verschlüsselt über TLS-Kommunikation. Die Daten werden zudem zusätzlich verschlüsselt. So musst du dir um die Sicherheit keine Sorgen mehr machen.',
            actions: _LearnMoreAboutPrivacyButton(),
          ),
        ],
      ),
    );
  }
}

class _LearnMoreAboutPrivacyButton extends StatelessWidget {
  const _LearnMoreAboutPrivacyButton();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('-> Erfahre mehr über den Datenschutz'),
      onPressed: () {
        openNavigationPage(context, NavigationItem.privacy);
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.teal),
      ),
    );
  }
}
