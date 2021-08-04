//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/profile/user_image_view.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/models/user.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:share/share.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';
import 'attachments/edit_attachments_view.dart';

void showSchoolLetterMoreSheet(BuildContext context,
    {required Letter initialData, required PlannerDatabase database}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<Letter?>(
            stream: database.letters.getItemStream(initialData.id),
            initialData: initialData,
            builder: (context, snapshot) {
              final letter = snapshot.data;
              if (letter == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, letter.title),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(getString(context).edit),
                    onTap: () {
                      pushWidget(
                          context,
                          NewLetterView.Edit(
                            database: database,
                            letter: letter,
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text(getString(context).share),
                    onTap: () {
                      Share.share(letter.title + '\n' + letter.content);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.autorenew),
                    title: Text(getString(context).resetresponses),
                    onTap: () {
                      showConfirmDialog(
                              context: context,
                              title: getString(context).reset,
                              action: getString(context).reset,
                              richtext: null)
                          .then((value) {
                        if (value == true) {
                          requestSavedInSimplePermission(
                                  context: context,
                                  database: database,
                                  category: PermissionAccessType.creator,
                                  savedin: letter.savedin!)
                              .then((result) {
                            if (result == true) {
                              Navigator.popUntil(context, (Route predicate) {
                                return (predicate.settings.name
                                            ?.startsWith('schoollettermore') ??
                                        true) ==
                                    false;
                              });
                              database.dataManager.ResetResponseLetter(letter);
                            }
                          });
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text(getString(context).delete),
                    onTap: () {
                      showConfirmDialog(
                              context: context,
                              title: getString(context).delete,
                              action: getString(context).delete,
                              richtext: null)
                          .then((value) {
                        if (value == true) {
                          requestSavedInSimplePermission(
                                  context: context,
                                  database: database,
                                  category: PermissionAccessType.creator,
                                  savedin: letter.savedin!)
                              .then((result) {
                            if (result == true) {
                              Navigator.popUntil(context, (Route predicate) {
                                return (predicate.settings.name
                                            ?.startsWith('schoollettermore') ??
                                        true) ==
                                    false;
                              });
                              database.dataManager.DeleteLetter(letter, true);
                            }
                          });
                        }
                      });
                    },
                  ),
                  FormSpace(16.0),
                ],
              );
            });
      },
      routname: 'schoollettermore');
}

String getSavedInValue(SavedIn savedin, PlannerDatabase database) {
  if (savedin == null) return '???';
  if (savedin.type == SavedInType.CLASS) {
    return database.getClassInfo(savedin.id!)!.getName();
  }
  if (savedin.type == SavedInType.COURSE) {
    return database.getCourseInfo(savedin.id!)!.getName();
  }
  throw Exception('Saved in value error!');
}

// ignore: must_be_immutable
class NewLetterView extends StatelessWidget {
  final PlannerDatabase database;
  final bool editmode;
  final ValueNotifier<Letter?> notifier = ValueNotifier(null);
  final ValueNotifier<bool> showOptions = ValueNotifier(false);
  bool changedValues = false;

  late Letter data;

  void update(Letter newdata) {
    data = newdata;
    notifier.value = newdata;
    changedValues = true;
  }

  void updateNotNotify(Letter newdata) {
    data = newdata;
    changedValues = true;
  }

  NewLetterView.Create({required this.database, SavedIn? savein})
      : editmode = false {
    data = Letter.Create(
            id: database.dataManager.generateCourseId(),
            authorid: database.getMemberId())
        .copyWith(
      savedin: savein,
    );
    notifier.value = data;
  }

  NewLetterView.Edit({required this.database, required Letter letter})
      : editmode = true {
    data = letter.copyWith();
    notifier.value = data;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<Letter?>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Scaffold(
                appBar: MyAppHeader(
                    title: editmode
                        ? getString(context).editletter
                        : getString(context).newletter),
                body: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    FormSpace(12.0),
                    FormTextField(
                      iconData: Icons.short_text,
                      text: data.title,
                      valueChanged: (newtext) {
                        updateNotNotify(data.copyWith(title: newtext));
                      },
                      labeltext: getString(context).title,
                      maxLength: 52,
                      maxLengthEnforced: true,
                      maxLines: 1,
                    ),
                    FormSpace(8.0),
                    FormTextField(
                      text: data.content,
                      valueChanged: (newtext) {
                        updateNotNotify(data.copyWith(content: newtext));
                      },
                      labeltext: getString(context).content,
                    ),
                    FormSpace(12.0),
                    FormDivider(),
                    FormHeader(getString(context).savein),
                    ListTile(
                      leading: Icon(Icons.widgets),
                      title: Text(data.savedin != null
                          ? (getSavedInValue(data.savedin!, database))
                          : '-'),
                      onTap: editmode
                          ? null
                          : () {
                              selectSavedin(
                                      context, database, data.savedin!.id!)
                                  .then((newsavedin) {
                                if (newsavedin != null) {
                                  print(newsavedin.id);
                                  update(data.copyWith(
                                      savedin: SavedIn(
                                          id: newsavedin.id,
                                          type: newsavedin.type)));
                                }
                              });
                            },
                      enabled: !editmode,
                      trailing: editmode
                          ? null
                          : (data.savedin == null
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    update(data.copyWithNull(savedin: null));
                                  })),
                    ),
                    FormDivider(),
                    FormHideable(
                        title: getString(context).options,
                        notifier: showOptions,
                        builder: (context) => Column(
                              children: <Widget>[
                                SwitchListTile(
                                  value: data.sendpush,
                                  onChanged: (newvalue) {
                                    update(data.copyWith(sendpush: newvalue));
                                  },
                                  title: Text(
                                      getString(context).pushnotifications),
                                ),
                                SwitchListTile(
                                  value: data.allowreply,
                                  onChanged: (newvalue) {
                                    update(data.copyWith(allowreply: newvalue));
                                  },
                                  title: Text(getString(context).allowreply),
                                ),
                              ],
                            )),
                    FormDivider(),
                    EditAttachementsView(
                      database: database,
                      attachments: data.files,
                      onAdded: (file) {
                        if (data.files == null) {
                          update(data.copyWith(files: {}));
                        }
                        data.files[file.fileid!] = file;
                        notifier.notifyListeners();
                      },
                      onRemoved: (file) {
                        if (data.files == null) {
                          update(data.copyWith(files: {}));
                        }
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
                      if (data.validate()) {
                        requestPermission().then((result) {
                          if (result) {
                            if (editmode) {
                              database.dataManager.ModifyLetter(data);
                              Navigator.pop(context);
                            } else {
                              database.dataManager.CreateLetter(data);
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
              );
            }),
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
        });
  }

  Future<bool> requestPermission() {
    if (data.savedin == null) {
      return Future.value(true);
    } else {
      if (data.savedin!.type == SavedInType.COURSE) {
        return requestPermissionCourse(
            database: database,
            category: PermissionAccessType.creator,
            courseid: data.savedin!.id!);
      } else if (data.savedin!.type == SavedInType.CLASS) {
        return requestPermissionClass(
            database: database,
            category: PermissionAccessType.creator,
            classid: data.savedin!.id!);
      }
      throw Exception('SOMETHING WENT WRONG???');
    }
  }
}

class LetterCard extends StatelessWidget {
  final Letter letter;
  final PlannerDatabase database;
  LetterCard({required this.letter, required this.database});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              title: Text(letter.title),
              subtitle: Row(
                children: <Widget>[
                  Icon(
                    Icons.public,
                    size: 15.0,
                    color: getTextColorLight(getBackgroundColor(context)),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(getDateTextDetailed(context, letter.published.toDate()))
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showSchoolLetterMoreSheet(context,
                        initialData: letter, database: database);
                  }),
            ),
            InkWell(
              onTap: () {
                pushWidget(
                    context,
                    LetterDetailedView(
                        initialdata: letter, database: database));
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                      text: letter.content,
                      style: TextStyle(
                          color: getClearTextColor(context),
                          fontWeight: FontWeight.w400)),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            letter.allowreply
                ? Card(
                    margin: EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text(letter.getMyResponse(database)?.message ??
                          getString(context).reply + '...'),
                      trailing: Icon(Icons.reply),
                      onTap: () {
                        getTextFromInput(
                                context: context,
                                previousText:
                                    letter.getMyResponse(database)?.message,
                                title: getString(context).reply)
                            .then(
                          (newtext) {
                            if (newtext != null) {
                              database.dataManager.SetResponseLetter(
                                  letter,
                                  LetterResponse.Create(
                                          id: database.dataManager
                                              .getMemberId())
                                      .copyWith(
                                          message: newtext,
                                          type: ResponseType.REPLY));
                            }
                          },
                        );
                      },
                      dense: true,
                    ),
                  )
                : nowidget(),
            Padding(
              padding:
                  EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0, right: 4.0),
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      pushWidget(
                          context,
                          LetterDetailedView(
                              initialdata: letter, database: database));
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                          getEventualTextColor(
                              context, getPrimaryColor(context))),
                    ),
                    child: Text(getString(context).details.toUpperCase()),
                  ),
                  letter.isRead(database)
                      ? nowidget()
                      : TextButton.icon(
                          onPressed: () {
                            database.dataManager.SetResponseLetter(
                                letter,
                                LetterResponse.Create(
                                        id: database.getMemberId())
                                    .copyWith(type: ResponseType.READ));
                          },
                          icon: Icon(Icons.check),
                          label:
                              Text(getString(context).markasread.toUpperCase()),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                getEventualTextColor(
                                    context, getPrimaryColor(context))),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LetterDetailedView extends StatelessWidget {
  final Letter initialdata;
  final PlannerDatabase database;
  LetterDetailedView({required this.initialdata, required this.database});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Letter?>(
        initialData: initialdata,
        stream: database.letters.getItemStream(initialdata.id),
        builder: (context, snapshot) {
          Letter? letter = snapshot.data;
          if (letter == null) return CircularProgressIndicator();
          return Scaffold(
            appBar:
                MyAppHeader(title: getSavedInValue(letter.savedin!, database)),
            backgroundColor: getBackgroundColor(context),
            body: ListView(
              children: <Widget>[
                Hero(
                  tag: 'lettercard:${letter.id}',
                  flightShuttleBuilder: (
                    BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext,
                  ) {
                    return SingleChildScrollView(
                      child: fromHeroContext.widget,
                    );
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(letter.title),
                          subtitle: Row(
                            children: <Widget>[
                              Icon(
                                Icons.public,
                                size: 15.0,
                                color: getTextColorLight(
                                    getBackgroundColor(context)),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(getDateTextDetailed(
                                  context, letter.published.toDate()))
                            ],
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: letter.content,
                                  style: TextStyle(
                                      color: getClearTextColor(context),
                                      fontWeight: FontWeight.w400)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Column(
                          children: letter.files.values.map((file) {
                            return ListTile(
                              leading: Icon(
                                file!.isImage()
                                    ? Icons.image
                                    : Icons.attach_file,
                                color: Colors.blue,
                              ),
                              title: Text(
                                file.name!,
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                OpenCloudFile(context, file);
                              },
                            );
                          }).toList(),
                        ),
                        letter.allowreply
                            ? Card(
                                margin: EdgeInsets.all(4.0),
                                child: ListTile(
                                  title: Text(
                                      letter.getMyResponse(database)?.message ??
                                          getString(context).reply + '...'),
                                  trailing: Icon(Icons.reply),
                                  onTap: () {
                                    getTextFromInput(
                                            context: context,
                                            previousText: letter
                                                .getMyResponse(database)
                                                ?.message,
                                            title: getString(context).reply)
                                        .then((newtext) {
                                      if (newtext != null) {
                                        database.dataManager.SetResponseLetter(
                                            letter,
                                            LetterResponse.Create(
                                                    id: database.dataManager
                                                        .getMemberId())
                                                .copyWith(
                                                    message: newtext,
                                                    type: ResponseType.REPLY));
                                      }
                                    });
                                  },
                                  dense: true,
                                ),
                              )
                            : nowidget(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 4.0, right: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              letter.isRead(database)
                                  ? nowidget()
                                  : TextButton.icon(
                                      onPressed: () {
                                        database.dataManager.SetResponseLetter(
                                            letter,
                                            LetterResponse.Create(
                                                    id: database.getMemberId())
                                                .copyWith(
                                                    type: ResponseType.READ));
                                      },
                                      icon: Icon(Icons.check),
                                      label: Text(getString(context)
                                          .markasread
                                          .toUpperCase()),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                getEventualTextColor(context,
                                                    getPrimaryColor(context))),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FormHeader2(getString(context).options),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(getString(context).informations),
                  onTap: () {
                    requestSavedInSimplePermission(
                            context: context,
                            database: database,
                            category: PermissionAccessType.creator,
                            savedin: letter.savedin!)
                        .then((result) {
                      if (result == true) {
                        pushWidget(
                            context,
                            LetterResponsesView(
                                initialdata: letter, database: database));
                      }
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(getString(context).edit),
                  onTap: () {
                    pushWidget(
                        context,
                        NewLetterView.Edit(
                          database: database,
                          letter: letter,
                        ));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text(getString(context).share),
                  onTap: () {
                    Share.share(letter.title + '\n' + letter.content);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.autorenew),
                  title: Text(getString(context).resetresponses),
                  onTap: () {
                    showConfirmDialog(
                            context: context,
                            title: getString(context).reset,
                            action: getString(context).reset,
                            richtext: null)
                        .then((value) {
                      if (value == true) {
                        requestSavedInSimplePermission(
                                context: context,
                                database: database,
                                category: PermissionAccessType.creator,
                                savedin: letter.savedin!)
                            .then((result) {
                          if (result == true) {
                            database.dataManager.ResetResponseLetter(letter);
                          }
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text(getString(context).delete),
                  onTap: () {
                    showConfirmDialog(
                            context: context,
                            title: getString(context).delete,
                            action: getString(context).delete,
                            richtext: null)
                        .then((value) {
                      if (value == true) {
                        requestSavedInSimplePermission(
                                context: context,
                                database: database,
                                category: PermissionAccessType.creator,
                                savedin: letter.savedin!)
                            .then((result) {
                          if (result == true) {
                            Navigator.popUntil(context, (Route predicate) {
                              return (predicate.settings.name
                                          ?.startsWith('schoollettermore') ??
                                      true) ==
                                  false;
                            });
                            database.dataManager.DeleteLetter(letter, true);
                          }
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}

Stream<Map<String, MemberData>> getMemberStream(
    SavedIn savedin, PlannerDatabase database) {
  if (savedin.type == SavedInType.COURSE) {
    return database.courseinfo
        .getItemStream(savedin.id!)
        .map((it) => it!.membersData);
  } else if (savedin.type == SavedInType.CLASS) {
    return database.schoolClassInfos
        .getItemStream(savedin.id!)
        .map((it) => it!.membersData);
  }
  throw Exception('Unsupported SavedIn Type!');
}

Map<String, MemberData> getMemberInitial(
    SavedIn savedin, PlannerDatabase database) {
  if (savedin.type == SavedInType.COURSE) {
    return database.getCourseInfo(savedin.id!)!.membersData;
  } else if (savedin.type == SavedInType.CLASS) {
    return database.getClassInfo(savedin.id!)!.membersData;
  }
  throw Exception('Unsupported SavedIn Type!');
}

class LetterResponsesView extends StatelessWidget {
  final Letter initialdata;
  final PlannerDatabase database;
  LetterResponsesView({required this.initialdata, required this.database});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TwoObjects<Letter?, Map<String, MemberData>?>>(
      initialData: TwoObjects(
          item: initialdata,
          item2: getMemberInitial(initialdata.savedin!, database)),
      stream: getMergedStream<Letter?, Map<String, MemberData>?>(
        database.letters.getItemStream(initialdata.id),
        getMemberStream(initialdata.savedin!, database),
      ),
      builder: (context, snapshot) {
        Letter? letter = snapshot.data!.item;
        Map<String, MemberData>? members = snapshot.data!.item2;
        if (letter == null) return CircularProgressIndicator();
        return Scaffold(
          appBar:
              MyAppHeader(title: getSavedInValue(letter.savedin!, database)),
          backgroundColor: getBackgroundColor(context),
          body: ListView(
            children: <Widget>[
              Hero(
                tag: 'lettercard:${letter.id}',
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return SingleChildScrollView(
                    child: fromHeroContext.widget,
                  );
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(letter.title),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(
                              Icons.public,
                              size: 15.0,
                              color: getTextColorLight(
                                  getBackgroundColor(context)),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(getDateTextDetailed(
                                context, letter.published.toDate()))
                          ],
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                          child: RichText(
                            text: TextSpan(
                                text: letter.content,
                                style: TextStyle(
                                    color: getClearTextColor(context),
                                    fontWeight: FontWeight.w400)),
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 4.0, bottom: 4.0, left: 4.0, right: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            letter.isRead(database)
                                ? nowidget()
                                : TextButton.icon(
                                    onPressed: () {
                                      database.dataManager.SetResponseLetter(
                                          letter,
                                          LetterResponse.Create(
                                                  id: database.getMemberId())
                                              .copyWith(
                                                  type: ResponseType.READ));
                                    },
                                    icon: Icon(Icons.check),
                                    label: Text(getString(context)
                                        .markasread
                                        .toUpperCase()),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              getEventualTextColor(context,
                                                  getPrimaryColor(context))),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FormHeader2(bothlang(context, de: 'Beantwortet', en: 'Replied')),
              Column(
                children: letter.responses.values
                    .where((it) => it.type == ResponseType.REPLY)
                    .map((it) => FutureBuilder<DocumentSnapshot>(
                          builder: (context, snapshot) {
                            final data = snapshot.data?.data();
                            UserProfile? userprofile = data != null
                                ? UserProfile.fromData(data)
                                : null;
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    leading: UserImageView(
                                      userProfile: userprofile,
                                    ),
                                    title: Text(userprofile?.name ??
                                        getString(context).anonymoususer),
                                    subtitle: Text(getDateTextDetailed(
                                        context, it.lastchanged.toDate())),
                                    trailing: IconButton(
                                        icon: Icon(Icons.content_copy),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: it.message ?? '-'));
                                          showToastMessage(
                                              msg: getString(context)
                                                  .addtoclipboard);
                                        }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      it.message ?? '-',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                ],
                              ),
                            );
                          },
                          future: database.dataManager
                              .getMemberInfo(it.getUid())
                              .get(),
                        ))
                    .toList(),
              ),
              FormHeader2(getString(context).readby),
              Column(
                children: letter.responses.values
                    .where((it) => it.type == ResponseType.READ)
                    .map((it) => FutureBuilder<DocumentSnapshot>(
                          builder: (context, snapshot) {
                            final data = snapshot.data?.data();
                            UserProfile? userprofile = data != null
                                ? UserProfile.fromData(data)
                                : null;
                            return ListTile(
                              leading: UserImageView(
                                userProfile: userprofile,
                              ),
                              title: Text(userprofile?.name ??
                                  getString(context).anonymoususer),
                              subtitle: Text(getDateTextDetailed(
                                  context, it.lastchanged.toDate())),
                            );
                          },
                          future: database.dataManager
                              .getMemberInfo(it.getUid())
                              .get(),
                        ))
                    .toList(),
              ),
              FormHeader2(getString(context).none),
              Column(
                children: members!.values
                    .where((it) {
                      LetterResponse? itresponse = letter.responses[it.id];
                      if (itresponse == null) return true;
                      if (itresponse.type == ResponseType.READ ||
                          itresponse.type == ResponseType.REPLY) return false;
                      return true;
                    })
                    .map((it) => FutureBuilder<DocumentSnapshot>(
                          builder: (context, snapshot) {
                            final data = snapshot.data?.data();
                            UserProfile? userprofile = data != null
                                ? UserProfile.fromData(data)
                                : null;
                            return ListTile(
                              leading: UserImageView(
                                userProfile: userprofile,
                              ),
                              title: Text(userprofile?.name ??
                                  getString(context).anonymoususer),
                            );
                          },
                          future: database.dataManager
                              .getMemberInfo(it.getUid())
                              .get(),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
