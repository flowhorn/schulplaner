import 'package:flutter/material.dart';
import 'package:schulplaner8/Chat/chatview.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_security_settings.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyLetters.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MySchoolClass.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_member_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_public_code.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_shared_settings.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class SchoolClassView extends StatelessWidget {
  final String classid;

  const SchoolClassView({
    required this.classid,
  });

  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return StreamBuilder<SchoolClass?>(
      builder: (context, snapshot) {
        SchoolClass? info = snapshot.data;
        if (info == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Design classdesign = info.getDesign();
        return Theme(
            data: newAppThemeDesign(context, classdesign),
            child: Scaffold(
              backgroundColor: getBackgroundColor(context),
              appBar: AppHeaderAdvanced(
                title: Text(info.getName()),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        showSchoolClassMoreSheet(context,
                            classid: classid, plannerdatabase: database);
                      }),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FormSection(
                        title: getString(context).informations,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Hero(
                                  tag: 'classtag:' + info.id,
                                  child: ColoredCircleText(
                                    color: info.getDesign().primary,
                                    text: toShortNameLength(
                                        context, info.getShortname_full()),
                                  )),
                              title: Text(info.getName()),
                              subtitle: info.description != null
                                  ? Text(info.description!)
                                  : null,
                            ),
                          ],
                        )),
                    FormHeader2(getString(context).schoolletters),
                    StreamBuilder<Map<String, Letter>>(
                      builder: (context, snapshot) {
                        List<Letter> datalist = snapshot.data!.values.where(
                            (letter) {
                          return letter.savedin?.id == info.id;
                        }).toList()
                          ..sort(
                              (l1, l2) => l1.published.compareTo(l2.published));
                        return Column(
                          children: datalist.map((letter) {
                            return LetterCard(
                              letter: letter,
                              database: database,
                            );
                          }).toList(),
                        );
                      },
                      stream: database.letters.stream.map((datamap) => datamap),
                      initialData: database.letters.data,
                    ),
                    ButtonBar(
                      children: <Widget>[
                        RButton(
                            text: getString(context).create,
                            onTap: () {
                              pushWidget(
                                  context,
                                  NewLetterView.Create(
                                    database: database,
                                    savein: SavedIn(
                                        id: info.id, type: SavedInType.CLASS),
                                  ));
                            },
                            iconData: Icons.add),
                      ],
                    ),
                    FormSection(
                        title: getString(context).publiccode,
                        child: SchoolClassPublicCodeView(
                          database: database,
                          classid: classid,
                        )),
                    FormSection(
                        title: getString(context).options,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.people_outline),
                              title: Text(getString(context).members),
                              subtitle:
                                  Text(info.membersData.length.toString()),
                              onTap: () {
                                pushWidget(
                                    context,
                                    SchoolClassMemberView(
                                        schoolClassID: classid,
                                        database: database));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.widgets),
                              title: Text(getString(context).courses),
                              subtitle: Text(info.courses.length.toString()),
                              onTap: () {
                                pushWidget(
                                    context,
                                    SchoolClassCoursesView(
                                        classid: classid, database: database));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.chat),
                              title: Text(getString(context).chat),
                              onTap: () {
                                pushWidget(
                                    context,
                                    Chat(
                                      database,
                                      info.getDesign(),
                                      groupid: classid,
                                      uid: database.uid,
                                    ));
                              },
                              trailing: RButton(
                                  text: 'BETA',
                                  onTap: null,
                                  disabledColor: Colors.orange),
                            ),
                            ListTile(
                              leading: Icon(Icons.settings_applications),
                              title: Text(bothlang(context,
                                  de: 'Geteilte Einstellungen',
                                  en: 'Shared settings')),
                              onTap: () {
                                pushWidget(
                                    context,
                                    SchoolClassSharedSettingsView(
                                        schoolClassID: classid,
                                        database: database));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.lock_outline),
                              title: Text(getString(context).security),
                              onTap: () {
                                pushWidget(
                                  context,
                                  SchoolClassSecuritySettings(classId: classid),
                                );
                              },
                            ),
                          ],
                        )),
                    FormSpace(64.0),
                  ],
                ),
              ),
            ));
      },
      stream: database.schoolClassInfos.getItemStream(classid),
      initialData: database.schoolClassInfos.data[classid],
    );
  }
}
