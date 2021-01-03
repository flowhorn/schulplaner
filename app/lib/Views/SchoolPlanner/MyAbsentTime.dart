import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/AbsentTime.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'attachments/edit_attachments_view.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class NewAbsentTimeView extends StatelessWidget {
  final PlannerDatabase database;
  final bool editmode;
  bool changedValues = false;

  AbsentTime data;
  ValueNotifier<AbsentTime> notifier;
  NewAbsentTimeView.Create({@required this.database, String date})
      : editmode = false {
    data =
        AbsentTime(id: database.dataManager.absentTimeRef.doc().id, date: date);
    notifier = ValueNotifier(data);
  }

  NewAbsentTimeView.Edit({@required this.database, AbsentTime absenttimedata})
      : editmode = true {
    data = absenttimedata.copy();
    notifier = ValueNotifier(data);
  }

  List<RecommendedDate> getRecommendedDatesSimple(BuildContext context) {
    return [
      RecommendedDate(text: getString(context).today, date: getDateToday()),
      RecommendedDate(
          text: getString(context).tomorrow, date: getDateTomorrow()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<AbsentTime>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Theme(
                  data: clearAppThemeData(context: context),
                  child: Scaffold(
                    appBar: MyAppHeader(
                        title: editmode
                            ? getString(context).editabsenttime
                            : getString(context).newabsenttime),
                    body: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        FormSpace(12.0),
                        FormTextField(
                          text: data.detail,
                          valueChanged: (newtext) {
                            data.detail = newtext;
                            changedValues = true;
                          },
                          labeltext: getString(context).title,
                          maxLength: 52,
                          maxLengthEnforced: true,
                          maxLines: 1,
                        ),
                        FormSpace(12.0),
                        FormDivider(),
                        ListTile(
                          leading: Icon(Icons.event),
                          title: Text(getString(context).date),
                          subtitle: Text(
                              data.date != null ? getDateText(data.date) : '-'),
                          onTap: () {
                            selectDateString(context, data.date)
                                .then((newDateString) {
                              if (newDateString != null) {
                                data.date = newDateString;
                                notifier.value = data;
                                notifier.notifyListeners();
                              }
                            });
                          },
                        ),
                        SingleChildScrollView(
                          child: ButtonBar(
                            children:
                                (getRecommendedDatesSimple(context)).map((rec) {
                              return RButton(
                                  text: rec.text,
                                  onTap: () {
                                    data.date = rec.date;
                                    notifier.value = data;
                                    notifier.notifyListeners();
                                  },
                                  enabled: rec.date != data.date,
                                  disabledColor: Colors.green,
                                  iconData: rec.date == data.date
                                      ? Icons.done
                                      : null);
                            }).toList(),
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
                        FormDivider(),
                        SwitchListTile(
                          value: data.unexcused,
                          onChanged: (newvalue) {
                            data.unexcused = newvalue;
                            notifier.value = data;
                            notifier.notifyListeners();
                          },
                          title: Text(getString(context).unexcused),
                        ),
                        ListTile(
                          title: Text(getString(context).amountoflessons),
                          subtitle: Text(data.amount == null
                              ? '-'
                              : (data.amount.toString() +
                                  ' ' +
                                  getString(context).lessons)),
                          onTap: () {
                            selectItem(
                                context: context,
                                items: buildIntList(
                                    database.getSettings().maxlessons,
                                    start: 1),
                                builder: (context, item) {
                                  bool isSelected = item == data.amount;
                                  return ListTile(
                                    title: Text(item.toString() +
                                        ' ' +
                                        getString(context).lessons),
                                    enabled: !isSelected,
                                    trailing: isSelected
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          )
                                        : null,
                                    onTap: () {
                                      Navigator.pop(context);
                                      data.amount = item;
                                      notifier.value = data;
                                      notifier.notifyListeners();
                                    },
                                  );
                                });
                          },
                        ),
                        FormDivider(),
                        EditAttachementsView(
                          database: database,
                          attachments: data.files,
                          onAdded: (file) {
                            if (data.files == null) data.files = {};
                            data.files[file.fileid] = file;
                            notifier.notifyListeners();
                          },
                          onRemoved: (file) {
                            if (data.files == null) data.files = {};
                            data.files[file.fileid] = null;
                            notifier.notifyListeners();
                          },
                        ),
                        FormDivider(),
                        FormSpace(64.0),
                      ],
                    )),
                    floatingActionButton: FloatingActionButton.extended(
                        onPressed: () {
                          if (data.validate()) {
                            var sheet =
                                showPermissionStateSheet(context: context);
                            Future.value(true).then((result) {
                              if (result) {
                                if (editmode) {
                                  database.dataManager.ModifyAbsentTime(data);
                                } else {
                                  database.dataManager.CreateAbsentTime(data);
                                }
                                sheet.value = true;
                                Future.delayed(Duration(milliseconds: 500))
                                    .then((_) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              } else {
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
                        label: Text(
                          getString(context).done,
                        )),
                  ));
            }),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
                  context: context,
                  title: getString(context).discardchanges,
                  action: getString(context).confirm,
                  richtext: RichText(
                      text: TextSpan(text: getString(context).pleasecheckdata)))
              .then((value) {
            if (value == true) {
              return true;
            } else {
              return false;
            }
          });
        });
  }
}

class MyAbsentList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;

  MyAbsentList({@required this.plannerDatabase});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          body: MyAbsentListInner(plannerDatabase),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              pushWidget(
                  context,
                  NewAbsentTimeView.Create(
                    database: plannerDatabase,
                  ));
            },
            icon: Icon(Icons.add),
            label: Text(getString(context).newabsenttime),
          ),
        ));
  }
}

class MyAbsentListInner extends StatefulWidget {
  final PlannerDatabase plannerDatabase;
  MyAbsentListInner(this.plannerDatabase);
  @override
  State<StatefulWidget> createState() => MyAbsentListInnerState();
}

class MyAbsentListInnerState extends State<MyAbsentListInner>
    with AutomaticKeepAliveClientMixin {
  PlannerDatabase get plannerDatabase => widget.plannerDatabase;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AbsentTime>>(
      stream: plannerDatabase.absentTime.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        List<AbsentTime> list = snapshot.data;
        return ListView.builder(
          itemBuilder: (context, index) {
            AbsentTime item = list[index];
            ListTile listTile = ListTile(
              leading: ColoredCircleIcon(
                icon: Icon(Icons.notifications_none),
                color: getAccentColor(context),
              ),
              title: Text(
                item.amount.toString() + ' ' + getString(context).absentlessons,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                children: <Widget>[
                  Text(
                    getString(context).date + ': ' + getDateText(item.date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.unexcused
                        ? getString(context).unexcused
                        : getString(context).excused,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: item.unexcused ? Colors.red : null),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              isThreeLine: true,
              onTap: () {
                showAbsentTimeDetailSheetCritical(
                  context,
                  absentTimeData: item,
                  plannerdatabase: plannerDatabase,
                );
              },
            );
            return listTile;
          },
          itemCount: list.length,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}

void showAbsentTimeDetailSheetCritical(
  BuildContext context, {
  @required AbsentTime absentTimeData,
  @required PlannerDatabase plannerdatabase,
}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<AbsentTime>(
            stream: plannerdatabase.dataManager.absentTimeRef
                .doc(absentTimeData.id)
                .snapshots()
                .map((snap) => snap.data != null
                    ? AbsentTime.fromData(snap.data())
                    : null),
            builder: (context, snapshot) {
              AbsentTime absenttime = snapshot.data;
              if (absenttime == null) return loadedView();
              return Expanded(
                  child: Column(
                children: <Widget>[
                  getSheetText(
                      context,
                      absenttime.amount.toString() +
                              ' ${getString(context).absentlessons}' ??
                          '-'),
                  getExpandList([
                    absenttime.date == null
                        ? nowidget()
                        : ListTile(
                            leading: Icon(Icons.event),
                            title: Text(getString(context).date +
                                ': ' +
                                getDateText(absenttime.date)),
                          ),
                    absenttime.detail == null
                        ? nowidget()
                        : ListTile(
                            leading: Icon(Icons.note),
                            title: Text(absenttime.detail),
                          ),
                    ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text(
                        absenttime.unexcused
                            ? getString(context).unexcused
                            : getString(context).excused,
                        style: TextStyle(
                            color: absenttime.unexcused ? Colors.red : null),
                      ),
                    ),
                    absenttime.files == null
                        ? nowidget()
                        : Column(
                            children: absenttime.files.values
                                .map((cloudfile) => ListTile(
                                      title: Text(cloudfile.name),
                                      leading: Icon(Icons.attach_file),
                                      subtitle: cloudfile.url == null
                                          ? null
                                          : Text(
                                              cloudfile.url,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                      onTap: () {
                                        OpenCloudFile(context, cloudfile);
                                      },
                                    ))
                                .toList(),
                          ),
                  ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonBar(
                      children: <Widget>[
                        RButton(
                            text: getString(context).more,
                            onTap: () {
                              showSheetBuilder(
                                  context: context,
                                  child: (context) {
                                    return getFlexList([
                                      ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text(getString(context).edit),
                                        onTap: () {
                                          Navigator.pop(context);
                                          pushWidget(
                                              context,
                                              NewAbsentTimeView.Edit(
                                                database: plannerdatabase,
                                                absenttimedata: absenttime,
                                              ));
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.delete_sweep,
                                          color: Colors.red,
                                        ),
                                        title: Text(getString(context).delete),
                                        onTap: () {
                                          showConfirmDialog(
                                            context: context,
                                            title: getString(context).delete,
                                          ).then((delete) {
                                            if (delete) {
                                              plannerdatabase.dataManager
                                                  .DeleteAbsentTime(absenttime);
                                              popNavigatorBy(context,
                                                  text: 'absenttimeid');
                                            }
                                          });
                                        },
                                      ),
                                    ]);
                                  },
                                  title: getString(context).more,
                                  routname: 'absenttimeid');
                            },
                            iconData: Icons.more_horiz),
                      ],
                    ),
                  ),
                  FormSpace(16.0),
                ],
                mainAxisSize: MainAxisSize.min,
              ));
            });
      },
      routname: 'absenttimeid');
}
