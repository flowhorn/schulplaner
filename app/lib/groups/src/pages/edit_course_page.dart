import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/groups/src/bloc/edit_course_bloc.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

Future<void> openEditCoursePage({
  required BuildContext context,
  required EditCourseBloc editCourseBloc,
}) async {
  await pushWidget(
    context,
    BlocProvider(
      bloc: editCourseBloc,
      child: EditCoursePage(),
    ),
  );
}

class EditCoursePage extends StatelessWidget {
  const EditCoursePage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditCourseBloc>(context);
    return WillPopScope(
      child: StreamBuilder<Course>(
          stream: bloc.currentCourse,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return CircularProgressIndicator();
            }
            final course = snapshot.data;
            return Theme(
              data: newAppThemeDesign(context, course?.design),
              child: Scaffold(
                appBar: MyAppHeader(
                    title: bloc.isEditMode
                        ? getString(context).editcourse
                        : getString(context).newcourse),
                body: SingleChildScrollView(
                  child: _Inner(
                    course: course,
                  ),
                ),
                floatingActionButton: _Fab(),
              ),
            );
          }),
      onWillPop: () async {
        if (bloc.hasChangedValues == false) return true;
        return showConfirmDialog(
            context: context,
            title: getString(context).discardchanges,
            action: getString(context).confirm,
            richtext: RichText(
                text: TextSpan(
              text: getString(context).currentchangesnotsaved,
            ))).then((value) {
          if (value == true) {
            return true;
          } else {
            return false;
          }
        });
      },
    );
  }
}

class _Inner extends StatelessWidget {
  final Course course;

  const _Inner({
    Key key,
    required this.course,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditCourseBloc>(context);
    return Column(
      children: <Widget>[
        FormHeader(getString(context).general),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StatefulTextField.standard(
            initialText: course.name,
            onChanged: bloc.changeName,
            labelText: getString(context).name,
          ),
        ),
        FormSpace(12.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StatefulTextField.standard(
            initialText: course.shortname,
            onChanged: bloc.changeShortname,
            iconData: Icons.short_text,
            labelText: getString(context).shortname,
            maxLengthEnforced: true,
            maxLength: 5,
          ),
        ),
        FormSpace(6.0),
        ListTile(
          leading: Icon(
            Icons.color_lens,
            color: course.design?.primary ?? Colors.grey,
          ),
          title: Text(getString(context).design),
          subtitle: Text(course.design?.name ?? '-'),
          trailing: IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () {
                bloc.changeDesign(getRandomDesign(context));
              }),
          onTap: () {
            selectDesign(context, course.design?.id).then((newDesign) {
              if (newDesign != null) {
                bloc.changeDesign(newDesign);
              }
            });
          },
        ),
        FormSpace(6.0),
        FormDivider(),
        FormStreamHideable(
          title: getString(context).teachers,
          switchState: bloc.changeShowTeacherForm,
          shouldShow: bloc.showTeacherForm,
          builder: (context) => Column(
            children: <Widget>[
              Column(
                children: [
                  for (final teacherLink in course.getTeacherLinks())
                    ListTile(
                      title: Text(teacherLink.name),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          bloc.removeTeacher(teacherLink.teacherid);
                        },
                      ),
                    ),
                ],
              ),
              FormButton(getString(context).addteacher, () {
                selectTeacher(context, bloc.database, course.teachers)
                    .then((teacher) {
                  if (teacher != null) {
                    bloc.addTeacher(teacher);
                  }
                });
              }),
            ],
          ),
        ),
        FormDivider(),
        FormStreamHideable(
            title: getString(context).places,
            shouldShow: bloc.showPlaceForm,
            switchState: bloc.changeShowPlaceForm,
            builder: (context) => Column(
                  children: <Widget>[
                    Column(
                      children: [
                        for (final placeLink in course.getPlaceLinks())
                          ListTile(
                            title: Text(placeLink.name),
                            trailing: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  bloc.removePlace(placeLink.placeid);
                                }),
                          ),
                      ],
                    ),
                    FormButton(getString(context).addplace, () {
                      selectPlace(context, bloc.database, course.teachers)
                          .then((place) {
                        if (place != null) {
                          bloc.addPlace(place);
                        }
                      });
                    }),
                  ],
                )),
        FormDivider(),
        FormStreamHideable(
            title: getString(context).connect,
            shouldShow: bloc.showConnectForm,
            switchState: bloc.changeShowConnectForm,
            builder: (context) => Column(
                  children: <Widget>[
                    bloc.isEditMode
                        ? ListTile(
                            title: Text(
                              getString(context).functionnotavailable,
                              textAlign: TextAlign.center,
                            ),
                            enabled: false,
                          )
                        : _Connect(),
                  ],
                )),
        FormDivider(),
        FormStreamHideable(
            title: getString(context).advanced,
            shouldShow: bloc.showSeveralForm,
            switchState: bloc.changeShowSeveralForm,
            builder: (context) => Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StatefulTextField.standard(
                        initialText: course.description,
                        onChanged: bloc.changeDescription,
                        labelText: getString(context).description,
                      ),
                    ),
                  ],
                )),
        FormDivider(),
        FormSpace(64.0),
      ],
    );
  }
}

class _Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditCourseBloc>(context);
    return FloatingActionButton.extended(
        onPressed: () {
          bloc.submit(context: context);
        },
        icon: Icon(Icons.done),
        label: Text(getString(context).done));
  }
}

class _Connect extends StatelessWidget {
  const _Connect({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditCourseBloc>(context);
    return StreamBuilder<String>(
        stream: bloc.schoolClassId,
        builder: (context, snapshot) {
          final schoolClassId = snapshot.data;
          return Column(
            children: <Widget>[
              SwitchListTile(
                value: bloc.addToPrivateCourses,
                onChanged: null,
                title: Text(getString(context).addtocourses),
              ),
              SwitchListTile(
                value: bloc.addToSchoolClass,
                onChanged: (newvalue) {
                  if (newvalue == true) {
                    _addSchoolClass(context);
                  } else {
                    _removeSchoolClass(context);
                  }
                },
                title: Text(schoolClassId == null
                    ? getString(context).addtoclass
                    : getString(context).addto +
                        ' ${bloc.database.schoolClassInfos.data[schoolClassId].getName()}'),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          );
        });
  }

  Future<void> _addSchoolClass(BuildContext context) async {
    final bloc = BlocProvider.of<EditCourseBloc>(context);
    await showSheetBuilder(
        context: context,
        child: (context) {
          return Flexible(
              child: SingleChildScrollView(
            child: Column(
              children: [
                for (final schoolClassInfo
                    in bloc.database.schoolClassInfos.data.values)
                  ListTile(
                    leading: ColoredCircleText(
                        text: schoolClassInfo.getShortname(length: 3),
                        color: schoolClassInfo.getDesign().primary,
                        radius: 22.0),
                    title: Text(schoolClassInfo.name),
                    onTap: () {
                      Navigator.pop(context);
                      bloc.addSchoolClass(schoolClassInfo.id);
                    },
                  ),
              ],
            ),
          ));
        },
        title: getString(context).addtoclass);
  }

  Future<void> _removeSchoolClass(BuildContext context) async {
    final bloc = BlocProvider.of<EditCourseBloc>(context);
    bloc.removeSchoolClass();
  }
}
