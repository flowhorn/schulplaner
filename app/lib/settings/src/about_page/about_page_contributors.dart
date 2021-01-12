import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schulplaner8/Helper/GitHub.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';

class AboutContributors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).about_contributors,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_AboutContributors(), _Contributors()],
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
                      en: 'The school planner is open source, so anyone can contribute to it. Below you can find a list, which was dynamically loaded directly from GitHub and includes all contributors! Click them to go to their GitHub account!')
                  .getText(context),
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
      height: 70, //todo multiply with length
      child: _myListView(context),
    );
  }
}

Widget _myListView(BuildContext context) {
  Future<List<Contributor>> list = GitHub().getContributors();

  List<Contributor> contrs = [];

//todo get List entries via FutureBuilder

  if (contrs.isEmpty) {
    Contributor contributor = Contributor(
      name: 'Loading failure',
      url: '',
      contributions: 0,
    );
    contrs.add(contributor);
  }

  return ListView.builder(
    itemCount: contrs.length,
    itemBuilder: (context, index) {
      return Card(
        //                           <-- Card widget
        child: ListTile(
          leading: Icon(FontAwesomeIcons.hands),
          title: Text(contrs[index].name),
          trailing: Text('Contributions: ' + contrs[index].contributions.toString()),
        ),
      );
    },
  );
}
