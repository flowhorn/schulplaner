import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/download_file/download_file.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage();
  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      key: ValueKey('PrivacyPageContent'),
      content: PrivacyPageContent(),
    );
  }
}

class PrivacyPageContent extends StatelessWidget {
  const PrivacyPageContent();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: const [
          SizedBox(height: 128),
          ResponsiveSides(
            first: Center(
              child: CircleAvatar(
                child: Icon(
                  Icons.privacy_tip_outlined,
                  size: 72,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
                radius: 72,
              ),
            ),
            second: _FirstSectionText(),
          ),
          SizedBox(height: 128),
          _PdfPrivacyPolicy(),
          SizedBox(height: 128),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}



class _FirstSectionText extends StatelessWidget {
  const _FirstSectionText();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Datenschutz!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'Schulplaner ist kein kommerzielles Produkt.\n'
          'Alle erhobenen Daten dienen ausschließlich der Funktionalität von Schulplaner\n'
          '-> Erfahre mehr darüber.',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class _PdfPrivacyPolicy extends StatelessWidget {
  const _PdfPrivacyPolicy();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final containerWidthFactor =
                (maxWidth > 600 ? 0.7 : 0.98) * maxWidth;
            return Container(
              width: containerWidthFactor,
              child: Column(
                children: const [
                  //_DownloadPrivacyPolicyTile(),
                  _PolicyContent(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _DownloadPrivacyPolicyTile extends StatelessWidget {
  const _DownloadPrivacyPolicyTile();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.picture_as_pdf),
      title: Text('Datenschutzerklärung'),
      trailing: IconButton(
        icon: Icon(Icons.download_outlined),
        onPressed: () {
          downloadFile('assets/privacy_policy_schulplaner.pdf',
              'Schulplaner Datenschutzerklärung.pdf');
        },
      ),
    );
  }
}

class _PolicyContent extends StatelessWidget {
  const _PolicyContent();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 32),
        _PolicyText(
          title: _Title('Datenschutzerklärung Schulplaner'),
          texts: [
            _ContentText(
              'Wir nehmen den Schutz ihrer persönlichen Daten sehr ernst und wollen transparent aufzeigen, was genau gespeichert wird und wie die Daten übertragen und gespeichert werden.'
              ' Dabei halten wir uns an die geltende Rechtslage und an unsere Datenschutzerklärung',
            ),
          ],
        ),
        _PolicyText(
          title: _Title('Was wird gespeichert?'),
          texts: [
            _ContentText(
              'Es werden nur die Daten gespeichert, die der Nutzer selber bewusst einträgt, heißt Hausaufgaben, Fächer etc.'
              ' Diese sind unter Umständen personenbezogen.'
              ' Bei Überspringung ist es möglich die Daten anonymisiert und nicht personenbezogen zu halten.'
              ' Es werden dabei keine Meta-Daten, Nutzungsdaten oder weiteres verwendet.'
              ' Auch greift die App auf keine Daten des Nutzers unberechtigt zu.'
              ' Für das Hinzufügen von Anhängen an Aufgaben, wie zum Beispiel Bilder oder Dokumente, wird eine Berechtigung für den Speicher benötigt.'
              ' Dies ist allerdings völlig optional und standardmäßig deaktiviert.'
              ' Für eine genaue Auflistung der erhobenen Daten siehe hier. Verwendete Produkte sind',
            ),
            _ContentText(
              '- Cloud Firestore\n'
              '- Cloud Functions for Firebase - Cloud Storage for Firebase\n'
              '- Firebase Cloud Messaging\n'
              '- Firebase Hosting\n',
            ),
          ],
        ),
        _PolicyText(
          title: _Title(
              'Informationen über Speicherung und Verarbeitung der Daten'),
          texts: [
            _ContentText(
              'Wir werten keine Daten aus oder geben sie an Dritte weiter. Nur für die Funktionen der Schulplaner-App relevante Daten werden gespeichert. Diese gehören den Nutzern. Auch gibt es keine Werbeanzeigen, welche personenbezogene Daten verwenden. Wir sorgen für die bestmögliche Sicherheit zum Schutz der Nutzer. Aus diesem Grund werden alle Übertragungen vertraulicher Inhalte mittels SSL- Verschlüsselung gesichert. Damit könne Dritte nicht mitlesen. Die Speicherung und Übertragung findet mittels des Dienstleisters Google Firebase statt, welcher höchste Sicherheit und Modernität bietet. Eine ausführliche Erläuterung über die Datenschutzbestimmung des Dienstleisters Google Firebase und die erhobenen Daten finden sie https://firebase.google.com/support/privacy/'
              'Der Server auf welchem die Daten gespeichert werden, sitzt in Frankfurt, Deutschland.',
            ),
          ],
        ),
        _PolicyText(
          title: _Title('Login und Analytics'),
          texts: [
            _ContentText(
              'Wir verwenden eine Schnittstellen von Google zum vereinfachten Anmelden.'
              ' Außerdem wird Google Analytics vewendet. Dadurch können wir Fehler und Bugs in der App schneller ausfindig machen und somit für die beste Nutzererfahrung und Sicherheit in der App sorgen.'
              ' Für die jeweiligen Datenschutzbestimmungen informieren sie sich bitte bei den Betreibern. Für alle Dienste besteht eine Opt-Out Möglichkeit. Sie können diese in den Einstellungen unter Datenschutz deaktivieren.',
            )
          ],
        ),
        _PolicyText(
          title: _Title('Generelle Hinweise'),
          texts: [
            _ContentText(
              'Wir weisen sie zuletzt auf ihre Rechte als Nutzer hin. Für sie gilt das - Auskunftsrecht (nach Art. 15 DSGVO)\n'
              '- Berichtigungsrecht (nach Art. 16 DSGVO)\n'
              '- Widerspruchsrecht (nach Art. 21 DSGVO)\n'
              '- Recht auf Löschung und Einschränkung der Verarbeitung von Daten (nach Art. 17 DSGVO)\n'
              '- Recht auf Vergessenwerden (nach Art. 17 DSGVO)\n'
              '- Recht auf Datenübertragbarkeit (nach Art. 20 DSGVO)\n'
              '- Recht auf Beschwerde bei Aufsichtsbehörden (nach Art. 77 DSGVO)\n'
              ' - Recht auf Widerruf von Einwilligungen (nach Art. 7 Abs. 3 DSGVO)',
            )
          ],
        ),
        _PolicyText(
          title: _Title('Weiteres'),
          texts: [
            _ContentText(
              'Auf Anfrage geben wir ihnen die vollkommene Einsicht in die gespeicherten Daten. Zur höchsten Transparenz geben wir diese zusätzlich im Originalformat weiter. Auch werden Alt-Daten auf Anfrage vollkommen gelöscht. Wir weisen darauf hin, dass jegliche Datenübertragung im Internet (z.B. bei der Kommunikation per E-Mail) Sicherheitslücken aufweisen kann. Ein absoluter Schutz der Daten vor dem Zugriff durch Dritte ist nicht möglich. Wir geben aber unser bestes, höchste Standards zu erfüllen.',
            )
          ],
        ),
        _PolicyText(
          title: _Title('Kontakt'),
          texts: [
            _ContentText(
              'Bei Fragen wenden Sie sich bitte an unseren Datenschutzbeauftragten.\n'
              'Felix Weuthen\n'
              'Klosterstraße 50\n'
              '41747 Viersen\n'
              'Email: danielfelixplay@gmail.com',
            )
          ],
        ),
      ],
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 6);
}

class _Title extends StatelessWidget {
  const _Title(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SelectableText(title, style: TextStyle(fontSize: 22));
  }
}

class _ContentText extends StatelessWidget {
  const _ContentText(this.subtitle, {Key? key}) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SelectableText(subtitle,
        style: TextStyle(fontWeight: FontWeight.w500));
  }
}

class _PolicyText extends StatelessWidget {
  const _PolicyText({Key? key, required this.title, required this.texts})
      : super(key: key);

  final Widget title;
  final List<Widget> texts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        title,
        ...texts,
        SizedBox(height: 32),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
