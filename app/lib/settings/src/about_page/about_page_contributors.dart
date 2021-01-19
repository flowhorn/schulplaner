import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schulplaner8/Helper/GitHub.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:url_launcher/url_launcher.dart';

int contributorCount = 1;

class AboutContributors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: bothlang(context, de: 'Mitwirkende', en: 'Contributors'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _AboutContributors(),
            _Contributors(),
          ],
        ),
      ),
    );
  }
}

class _AboutContributors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormSection(
        title: BothLangString(de: 'Mitwirkende am Schulplaner', en: 'Schoolplanner\'s collaborators').getText(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FormSectionText(
                text: DefaultTextSpan(
              context,
              BothLangString(
                de: 'Der Schulplaner ist Open-Source, sodass jeder daran mitwirken kann. Unten findet ihr eine Liste, welche dynamisch direkt von GitHub geladen wurde und alle Mitwirkenden beinhaltet! Klicke sie an, um zu ihrem GitHub Account zu gelangen!',
                en: 'The school planner is open source, so anyone can contribute to it. Below you can find a list, which was dynamically loaded directly from GitHub and includes all contributors! Click them to go to their GitHub account!',
              ).getText(context),
            )),
            SizedBox(
              height: 20.0,
            )
          ],
        ));
  }
}

class _Contributors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _ContributorsList(),
      height: contributorCount.toDouble() * 70,
    );
  }
}

class _ContributorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contributor>>(
      future: GitHub().getContributors(),
      builder: (context, snapshot) {
        final contributors = snapshot.data;

        //Because the value can be null
        if (contributors == null || !snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(ColorUtils.of(context).getAccentColor()),
          ));
        }

        contributorCount = contributors.length;

        return ListView.builder(
          itemCount: contributors.length,
          itemBuilder: (context, index) {
            final _contributor = contributors[index];
            return _ContributorListTile(contributor: _contributor);
          },
        );
      },
    );
  }
}

class _ContributorListTile extends StatelessWidget {
  final Contributor contributor;
  const _ContributorListTile({this.contributor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.github),
      title: Text(contributor.name),
      trailing: Text(
        BothLangString(
          de: 'Beiträge: ' + contributor.contributions.toString(),
          en: 'Contributions: ' + contributor.contributions.toString(),
        ).getText(context),
      ),
      onTap: () {
        launch(contributor.url);
      },
    );
  }
}
