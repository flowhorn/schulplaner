import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/SchoolPlanner/attachments/edit_attachments_view.dart';
import 'package:schulplaner8/app_base/src/blocs/app_stats_bloc.dart';
import 'package:schulplaner_addons/common/widgets/editpage.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/SmartCalAPI.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/common/edit_page.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

// ignore: must_be_immutable
class NewSchoolTaskView extends StatelessWidget {
  final PlannerDatabase database;
  final bool editmode;
  final String? editmode_taskid;
  bool changedValues = false;
  List<String>? _nextlessons;
  List<RecommendedDate>? recommendeddates;
  late SchoolTask data;
  late ValueNotifier<SchoolTask> notifier;

  ValueNotifier<bool> showmore = ValueNotifier(false);

  NewSchoolTaskView(
      {required this.database, this.editmode = false, this.editmode_taskid}) {
    if (editmode) {
      data = database.tasks.data[editmode_taskid!]!.copy();
    } else {
      data = SchoolTask(
        files: {},
        title: '',
        detail: '',
        finished: {},
      );
      try {
        data.courseid = potentialcourseidnow(database)!;
        if (data.due == null && data.courseid != null) {
          _nextlessons = getNextLessons(database, data.courseid!, count: 2);
          if (_nextlessons?.isNotEmpty ?? false) {
            data.due = _nextlessons![0];
          }
        }
      } catch (_) {}
    }
    notifier = ValueNotifier(data);
  }

  NewSchoolTaskView.fromCriticalEdit(
      {required this.database, required SchoolTask task})
      : editmode = true,
        editmode_taskid = null {
    data = task.copy();
    notifier = ValueNotifier(data);
  }

  NewSchoolTaskView.CreateWithData(
      {required this.database, String? due, String? courseid})
      : editmode = false,
        editmode_taskid = null {
    data = SchoolTask(
      due: due,
      courseid: courseid,
      title: '',
      files: {},
      finished: {},
      detail: '',
    );
    if (data.due == null && data.courseid != null) {
      _nextlessons = getNextLessons(database, data.courseid!, count: 2);
      if (_nextlessons?.isNotEmpty ?? false) {
        data.due = _nextlessons![0];
      }
    }
    notifier = ValueNotifier(data);
  }

  List<RecommendedDate> getRecommendedDatesSimple(BuildContext? context) {
    return [
      RecommendedDate(text: getString(context).today, date: getDateToday()),
      RecommendedDate(
          text: getString(context).tomorrow, date: getDateTomorrow()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (recommendeddates == null) {
      recommendeddates = (_nextlessons ?? []).map((date) {
        int? index = _nextlessons?.indexOf(date);
        String? text;
        if (index == 0) {
          text = getString(context).nextlesson;
        } else if (index == 1) {
          text = getString(context).lessonafternext;
        }
        return RecommendedDate(
            date: date, text: text ?? getString(context).nextlesson);
      }).toList()
        ..addAll(getRecommendedDatesSimple(null));
    }
    return WillPopScope(
      onWillPop: () async {
        if (changedValues == false) return true;
        return showConfirmDialog(
                context: context,
                title: getString(context).discardchanges,
                action: getString(context).confirm,
                richtext: RichText(
                    text: TextSpan(
                        text: getString(context).currentchangesnotsaved)))
            .then((value) {
          if (value == true) {
            return true;
          } else {
            return false;
          }
        });
      },
      child: ValueListenableBuilder<SchoolTask>(
        valueListenable: notifier,
        builder: (context, _, _2) {
          if (data == null) return CircularProgressIndicator();
          return Theme(
            data: getTaskTheme(context),
            child: Scaffold(
              appBar: MyAppHeader(
                  title: editmode
                      ? getString(context).edittask
                      : getString(context).newtask),
              body: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  FormSpace(12.0),
                  FormTextField(
                    text: data.title,
                    valueChanged: (newtext) {
                      data.title = newtext;
                      changedValues = true;
                    },
                    labeltext: getString(context).title,
                    maxLength: 52,
                    maxLengthEnforced: true,
                    maxLines: 1,
                  ),
                  FormSpace(12.0),
                  const Divider(),
                  EditCourseField(
                    courseId: data.courseid,
                    editmode: editmode,
                    onChanged: (context, newCourse) {
                      data.courseid = newCourse.id;
                      notifier.value = data;

                      List<String> nextlessons =
                          getNextLessons(database, data.courseid!, count: 1);
                      if (data.due == null && nextlessons.isNotEmpty) {
                        data.due = nextlessons[0];
                      }
                      recommendeddates = nextlessons
                          .map((date) => RecommendedDate(
                              date: date, text: getString(context).nextlesson))
                          .toList()
                        ..addAll(getRecommendedDatesSimple(context));
                      notifier.notifyListeners();
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(getString(context).saveprivately),
                    value: data.private,
                    onChanged: editmode
                        ? null
                        : (newvalue) {
                            data.private = newvalue;
                            notifier.value = data;
                            notifier.notifyListeners();
                          },
                  ),
                  const Divider(),
                  FormHeader(getString(context).due),
                  EditDateField(
                    date: data.due,
                    label: getString(context).due,
                    onChanged: (newDate) {
                      data.due = newDate;
                      notifier.value = data;
                      notifier.notifyListeners();
                    },
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ButtonBar(
                      children: (recommendeddates ??
                              getRecommendedDatesSimple(context))
                          .map((rec) {
                        return RButton(
                            text: rec.text,
                            onTap: () {
                              data.due = rec.date;
                              notifier.value = data;
                              notifier.notifyListeners();
                            },
                            enabled: rec.date != data.due,
                            disabledColor: Colors.green,
                            iconData: rec.date == data.due ? Icons.done : null);
                      }).toList(),
                    ),
                  ),
                  FormDivider(),
                  FormHideable(
                      title: getString(context).more,
                      notifier: showmore,
                      builder: (context) => Column(
                            children: <Widget>[
                              FormTextField(
                                text: data.detail,
                                valueChanged: (newtext) {
                                  data.detail = newtext;
                                  changedValues = true;
                                },
                                labeltext: getString(context).detail,
                              ),
                              FormSpace(16.0)
                            ],
                          )),
                  FormDivider(),
                  EditAttachementsView(
                    database: database,
                    attachments: data.files,
                    onAdded: (file) {
                      if (data.files == null) data.files = {};
                      data.files[file.fileid!] = file;
                      notifier.notifyListeners();
                    },
                    onRemoved: (file) {
                      if (data.files == null) data.files = {};
                      data.files[file.fileid!] = null;
                      notifier.notifyListeners();
                    },
                  ),
                  FormDivider(),
                  FormSpace(64.0),
                ],
              )),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    if ((editmode && data.validate()) ||
                        (editmode == false && data.validateCreate())) {
                      requestPermission().then((result) {
                        if (result) {
                          if (editmode) {
                            database.dataManager.ModifySchoolTask(data);
                            Navigator.pop(context);
                          } else {
                            database.dataManager.CreateSchoolTask(data);
                            BlocProvider.of<AppStatsBloc>(context)
                                .incrementAddedTask();
                            Navigator.pop(context);
                          }
                        } else {
                          var sheet =
                              showPermissionStateSheet(context: context);
                          sheet.value = false;
                        }
                      });
                    } else {
                      final infoDialog = InfoDialog(
                        title: getString(context).failed,
                        message: getString(context).pleasecheckdata,
                      );
                      // ignore: unawaited_futures
                      infoDialog.show(context);
                    }
                  },
                  icon: Icon(Icons.done),
                  label: Text(getString(context).done)),
            ),
          );
        },
      ),
    );
  }

  ThemeData getTaskTheme(BuildContext context) {
    if (data.courseid != null) {
      return newAppThemeDesign(
          context, database.courseinfo.data[data.courseid]?.getDesign());
    } else {
      if (data.classid != null) {
        return newAppThemeDesign(
            context, database.schoolClassInfos.data[data.classid]?.getDesign());
      } else {
        return clearAppThemeData(context: context);
      }
    }
  }

  Future<bool> requestPermission() {
    if (data.private == true) {
      return Future.value(true);
    } else {
      if (data.courseid != null) {
        return requestPermissionCourse(
            database: database,
            category: PermissionAccessType.creator,
            courseid: data.courseid!);
      } else {
        if (data.classid != null) {
          return requestPermissionClass(
              database: database,
              category: PermissionAccessType.creator,
              classid: data.classid!);
        } else {
          throw Exception('SOMETHING WENT WRONG???');
        }
      }
    }
  }
}
