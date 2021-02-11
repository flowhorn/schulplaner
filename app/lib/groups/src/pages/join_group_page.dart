import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/PublicCode.dart';
import 'package:schulplaner8/Helper/MyCloudFunctions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/groups/src/bloc/join_group_bloc.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_functions/schulplaner_functions.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';

Future<void> openGroupJoinPage({
  required BuildContext context,
  String initialCode,
}) async {
  return openGroupJoinPageByNavigationBloc(
    navigationBloc: NavigationBloc.of(context),
    initialCode: initialCode,
  );
}

Future<void> openGroupJoinPageByNavigationBloc({
  required NavigationBloc navigationBloc,
  String initialCode,
}) async {
  final joinGroupBloc = JoinGroupBloc(initialCode: initialCode);
  await navigationBloc.openSubPage(
    builder: (context) => BlocProvider<JoinGroupBloc>(
      bloc: joinGroupBloc,
      child: _JoinGroupPage(),
    ),
  );
}

class _JoinGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).join,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      getString(context).publiccode,
                    ),
                  ),
                  Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16.0,
                        ),
                        _TextField(),
                        SizedBox(
                          width: 16.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.0),
                          child: _SearchFab(),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center),
                  FormSpace(16.0),
                  /*
                  ButtonBar(
                    children: <Widget>[
                      RButton(text: "Einladungslink eingeben", onTap: () {})
                    ],
                  ),
                  */
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              margin: EdgeInsets.all(8.0),
            ),
            FormSpace(16.0),
            _Result(),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinGroupBloc = BlocProvider.of<JoinGroupBloc>(context);
    return Flexible(
      child: StreamBuilder<String>(
          stream: joinGroupBloc.enteredCode,
          initialData: joinGroupBloc.enteredCodeValue,
          builder: (context, snapshot) {
            final text = snapshot.data;
            return StatefulTextField.standard(
              initialText: text,
              onChanged: joinGroupBloc.changeEnteredCode,
              prefixText: '#',
              maxLines: 1,
              maxLengthEnforced: true,
              maxLength: 6,
            );
          }),
    );
  }
}

class _SearchFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinGroupBloc = BlocProvider.of<JoinGroupBloc>(context);
    return FloatingActionButton.extended(
      onPressed: () {
        joinGroupBloc.submitSearch(context);
      },
      icon: Icon(Icons.search),
      label: Text(getString(context).search),
    );
  }
}

class _Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinGroupBloc = BlocProvider.of<JoinGroupBloc>(context);
    return StreamBuilder<PublicCode>(
      stream: joinGroupBloc.publicCodeResult,
      builder: (context, snapshot) {
        final codeValue = snapshot.data;
        final enteredCodeValue = joinGroupBloc.enteredCodeValue;
        return Column(
          children: <Widget>[
            Text(
              codeValue == null
                  ? '${getString(context).noresultfor} #' +
                      (enteredCodeValue ?? '??????')
                  : ('${getString(context).resultfor} #' + enteredCodeValue),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            FormSpace(16.0),
            if (codeValue != null)
              _CodeValueBuilder(
                codeValue: codeValue,
              ),
            FormSpace(16.0),
          ],
        );
      },
    );
  }
}

class _CodeValueBuilder extends StatelessWidget {
  final PublicCode codeValue;

  const _CodeValueBuilder({Key key, required this.codeValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (codeValue.codetype == 0) {
        return _Course(codeValue: codeValue);
      } else if (codeValue.codetype == 1) {
        return _SchoolClass(codeValue: codeValue);
      }
      return Container();
    });
  }
}

class _Course extends StatelessWidget {
  final PublicCode codeValue;
  const _Course({Key key, this.codeValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return FutureBuilder<Course>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return Icon(Icons.error);
          }
          final courseInfo = snapshot.data;
          return FormSection(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: ColoredCircleText(
                      text: toShortNameLength(
                          context, courseInfo.getShortname_full()),
                      color: courseInfo.getDesign().primary,
                      radius: 22.0),
                  title: Text(courseInfo.name),
                  subtitle: Column(
                    children: <Widget>[
                      Text(
                        getString(context).teacher +
                            ': ' +
                            courseInfo.getTeachersListed(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(getString(context).place +
                          ': ' +
                          courseInfo.getPlacesListed()),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  isThreeLine: true,
                  trailing: StreamBuilder<Map<String, Course>>(
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return CircularProgressIndicator();
                      }
                      final isAlreadyInCourse =
                          snapshot.data.containsKey(courseInfo.id);

                      return isAlreadyInCourse
                          ? RButton(
                              text: getString(context).added,
                              onTap: null,
                              iconData: Icons.done,
                              enabled: false,
                              disabledColor: Colors.green)
                          : RButton(
                              text: getString(context).add,
                              onTap: () {
                                _tryJoinCourse(context, courseInfo);
                              },
                              iconData: Icons.add_circle_outline,
                              enabled: true);
                    },
                    stream: database.courseinfo.stream,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text(
                      (courseInfo?.membersData?.length?.toString() ?? '?') +
                          ' ${getString(context).members}'),
                ),
                ListTile(
                  leading: Icon(Icons.short_text),
                  title: Text(getString(context).description),
                  subtitle: Text(courseInfo?.description ?? '-'),
                )
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
      future: getCourseInformation(codeValue.referedid),
    );
  }

  Future<void> _tryJoinCourse(BuildContext context, Course course) async {
    if (course.settings.isPublic == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(bothlang(context,
            de: 'Dieses Fach ist nicht öffentlich',
            en: 'This course is not public!')),
      ));
      return;
    }
    final sheet_notifier = ValueNotifier<bool>(null);
    showLoadingStateSheet(context: context, sheetUpdate: sheet_notifier);
    final schulPlanerFunctions = SchulplanerFunctionsBloc.of(context);
    final joinGroupResult = await schulPlanerFunctions.joinGroup(
      groupId: course.id,
      groupType: GroupType.course,
      myMemberId: PlannerDatabaseBloc.getDatabase(context).getMemberId(),
    );
    sheet_notifier.value = joinGroupResult.data ?? false;
  }
}

class _SchoolClass extends StatelessWidget {
  final PublicCode codeValue;
  const _SchoolClass({Key key, this.codeValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return FutureBuilder<SchoolClass>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return Icon(Icons.error);
          }
          final info = snapshot.data;
          return FormSection(
            child: Column(
              children: <Widget>[
                FormSpace(8.0),
                ListTile(
                  leading: ColoredCircleText(
                      text: info.getShortname(length: 3),
                      color: info.getDesign().primary,
                      radius: 22.0),
                  title: Text(info.name),
                  trailing: StreamBuilder<Map<String, SchoolClass>>(
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return CircularProgressIndicator();
                      }
                      final isAlreadyInClass =
                          snapshot.data?.containsKey(info.id) ?? false;

                      return isAlreadyInClass
                          ? RButton(
                              text: getString(context).added,
                              onTap: null,
                              iconData: Icons.done,
                              enabled: false,
                              disabledColor: Colors.green)
                          : RButton(
                              text: getString(context).add,
                              onTap: () {
                                _tryJoinSchoolClass(context, info);
                              },
                              iconData: Icons.add_circle_outline,
                              enabled: true);
                    },
                    stream: database.schoolClassInfos.stream,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text((info?.membersData?.length?.toString() ?? '?') +
                      ' ${getString(context).members}'),
                ),
                ListTile(
                  leading: Icon(Icons.widgets),
                  title: Text((info?.courses?.length?.toString() ?? '?') +
                      ' ${getString(context).courses}'),
                ),
                ListTile(
                  leading: Icon(Icons.short_text),
                  title: Text(
                    getString(context).description,
                  ),
                  subtitle: Text(info?.description ?? '-'),
                )
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
      future: getSchoolClassInformation(codeValue.referedid),
    );
  }

  Future<void> _tryJoinSchoolClass(
      BuildContext context, SchoolClass schoolClass) async {
    if (schoolClass.settings.isPublic == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(bothlang(context,
            de: 'Diese Klasse ist nicht öffentlich',
            en: 'This class is not public!')),
      ));
      return;
    }

    final sheet_notifier = ValueNotifier<bool>(null);
    showLoadingStateSheet(context: context, sheetUpdate: sheet_notifier);
    final schulPlanerFunctions = SchulplanerFunctionsBloc.of(context);
    final joinGroupResult = await schulPlanerFunctions.joinGroup(
      groupId: schoolClass.id,
      groupType: GroupType.schoolClass,
      myMemberId: PlannerDatabaseBloc.getDatabase(context).getMemberId(),
    );
    sheet_notifier.value = joinGroupResult.data ?? false;
  }
}
