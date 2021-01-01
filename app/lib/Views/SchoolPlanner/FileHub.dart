import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/files/pages/new_file_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:share/share.dart';

class FileHub extends StatelessWidget {
  final PlannerDatabase database;
  FileHub({@required this.database});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getBackgroundColor(context),
      child: StreamBuilder<Map<String, Course>>(
        builder: (context, snapshot) {
          List<Course> courses = snapshot.data.values.toList()
            ..sort((c1, c2) => c1.getName().compareTo(c2.getName()));
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormSection(
                    title: getString(context).mystorage,
                    child: ListTile(
                      leading: Hero(
                          tag: "personalstorage_icon",
                          child: Icon(Icons.person_outline)),
                      title: Hero(
                          tag: "personalstorage_text",
                          child: Material(
                            child: Text(
                              getString(context).personalstorage,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400),
                            ),
                            color: Colors.transparent,
                          )),
                      onTap: () {
                        pushWidget(
                            context, PersonalStorageView(database: database));
                      },
                    )),
                FormSection(
                    title: getString(context).coursestorage,
                    child: Column(
                      children: courses
                          .map((courseInfo) => ListTile(
                                leading: Hero(
                                    tag: "courseicon_" + courseInfo.id,
                                    child: ColoredCircleText(
                                        text: toShortNameLength(context,
                                            courseInfo.getShortname_full()),
                                        color: courseInfo.getDesign().primary,
                                        radius: 22.0)),
                                title: Hero(
                                    tag: "coursetext_" + courseInfo.id,
                                    child: Material(
                                      child: Text(
                                        courseInfo.getName(),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      color: Colors.transparent,
                                    )),
                                onTap: () {
                                  pushWidget(
                                      context,
                                      CourseStorageView(
                                        database: database,
                                        courseInfo: courseInfo,
                                      ));
                                },
                              ))
                          .toList(),
                    )),
                FormSpace(64.0),
              ],
            ),
          );
        },
        stream: database.courseinfo.stream,
        initialData: database.courseinfo.data,
      ),
    );
  }
}

class PersonalStorageView extends StatelessWidget {
  final PlannerDatabase database;
  PersonalStorageView({@required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getString(context).files),
        bottom: PreferredSize(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Hero(
                        tag: "personalstorage_icon",
                        child: ColoredCircleIcon(
                            icon: Icon(
                              Icons.person_outline,
                              color: getPrimaryColor(context),
                            ),
                            color: getTextColor(getPrimaryColor(context)),
                            radius: 26.0)),
                    FormSpace(6.0),
                    Hero(
                        tag: "personalstorage_text",
                        child: Material(
                          child: Text(
                            getString(context).personalstorage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                                color: getTextColor(getPrimaryColor(context))),
                          ),
                          color: Colors.transparent,
                        )),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
            preferredSize: Size(double.infinity, 110.0)),
      ),
      body: StreamBuilder<List<CloudFile>>(
        builder: (context, snapshot) {
          List<CloudFile> files = snapshot.data ?? [];
          return UpListView(
            builder: (context, file) {
              if (file == null) return LinearProgressIndicator();
              return Builder(
                builder: (context) {
                  return ListTile(
                    leading: ColoredCircleIcon(
                      icon: Icon(
                          file.isImage() ? Icons.image : Icons.attach_file),
                    ),
                    title: Text(file.name ?? "-"),
                    subtitle: file.fileform == FileForm.WEBLINK
                        ? Text(file.url ?? "?")
                        : null,
                    onTap: () {
                      OpenCloudFile(context, file);
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {
                          showFilePersonalMoreSheet(context,
                              fileid: file.fileid, database: database);
                        }),
                  );
                },
              );
            },
            items: files,
          );
        },
        stream: database.personalfiles.stream,
        initialData: database.personalfiles.data,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            openNewFilePage(context);
          },
          icon: Icon(Icons.add),
          label: Text(getString(context).newfile)),
    );
  }
}

class CourseStorageView extends StatelessWidget {
  final PlannerDatabase database;
  final Course courseInfo;
  CourseStorageView({@required this.database, @required this.courseInfo});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: newAppThemeDesign(context, courseInfo.getDesign()),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(getString(context).files),
              bottom: PreferredSize(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          Hero(
                              tag: "courseicon_" + courseInfo.id,
                              child: ColoredCircleText(
                                  text: toShortNameLength(
                                      context, courseInfo.getShortname_full()),
                                  color: getTextColor(getPrimaryColor(context)),
                                  radius: 22.0)),
                          FormSpace(6.0),
                          Hero(
                              tag: "coursetext_" + courseInfo.id,
                              child: Material(
                                child: Text(
                                  courseInfo.getName(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: getTextColor(
                                          getPrimaryColor(context))),
                                ),
                                color: Colors.transparent,
                              )),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                  ),
                  preferredSize: Size(double.infinity, 110.0)),
            ),
            body: Center(
              child: Text(bothlang(context,
                  de: "Bald verfügbar. Benutze solange den persönlichen Speicher",
                  en: "Coming soon. Until then use the personal storage")),
            ),
          );
        }));
  }
}

void showFilePersonalMoreSheet(BuildContext context,
    {@required String fileid, @required PlannerDatabase database}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<CloudFile>(
            initialData: database.personalfiles.getItem(fileid),
            stream: database.personalfiles.getItemStream(fileid),
            builder: (context, snapshot) {
              CloudFile file = snapshot.data;
              if (file == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, file.name ?? "-"),
                  SingleChildScrollView(
                    child: Column(children: [
                      ListTile(
                        leading: Icon(Icons.open_in_new),
                        title: Text(getString(context).open),
                        onTap: () {
                          OpenCloudFile(context, file);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text(getString(context).share),
                        onTap: () {
                          Share.share(file.url);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete_forever),
                        title: Text(getString(context).delete),
                        onTap: () {
                          showConfirmDialog(
                                  context: context,
                                  title: getString(context).delete)
                              .then((result) {
                            if (result == true) {
                              database.dataManager.DeleteFile(file);
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                      FormSpace(16.0),
                    ]),
                  ),
                ],
              );
            });
      });
}
