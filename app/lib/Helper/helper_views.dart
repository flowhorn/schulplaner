import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Extras/qrimage2.dart';
import 'package:schulplaner8/Helper/database_foundation.dart';
import 'package:schulplaner8/Helper/helper_data.dart';

typedef Widget DataCollectionWidgetBuilder<T>(
    BuildContext context, List<T> data);
typedef Widget DataDocumentWidgetBuilder<T>(BuildContext context, T data);

class DataCollectionWidget<T> extends StatelessWidget {
  final DataCollectionPackage<T> package;
  final DataCollectionWidgetBuilder<T> builder;
  DataCollectionWidget({required this.package, required this.builder});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>?>(
      builder: (BuildContext context, asyncSnapshot) {
        if (asyncSnapshot.data == null) {
          return SizedBox(
            height: 40.0,
            width: 40.0,
            child: CircularProgressIndicator(),
          );
        } else {
          return builder(context, asyncSnapshot.data ?? []);
        }
      },
      initialData: package.data,
      stream: package.stream,
    );
  }
}

class DataItemWidget<T> extends StatelessWidget {
  final DataCollectionPackage<T> package;
  final DataDocumentWidgetBuilder<T> builder;
  final String id;
  DataItemWidget(
      {required this.package, required this.builder, required this.id});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
      builder: (BuildContext context, asyncSnapshot) {
        if (asyncSnapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          return builder(context, asyncSnapshot.data!);
        }
      },
      initialData: package.getItem(id),
      stream: package.getItemStream(id),
    );
  }
}

class DataDocumentWidget<T> extends StatelessWidget {
  final DataDocumentPackage<T> package;
  final DataDocumentWidgetBuilder<T?> builder;
  final bool allowNull;
  DataDocumentWidget(
      {required this.package, required this.builder, this.allowNull = false});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
      builder: (BuildContext context, asyncSnapshot) {
        if (allowNull) {
          return builder(context, asyncSnapshot.data);
        } else {
          if (asyncSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return builder(context, asyncSnapshot.data);
          }
        }
      },
      initialData: package.data,
      stream: package.stream,
    );
  }
}

Future<String?> getTextFromInput(
    {required BuildContext context,
    required String? previousText,
    required String title,
    TextInputType keyboardType = TextInputType.text,
    int? maxlength}) async {
  String inputtext = previousText ?? '';
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(getString(context).enter),
        content: TextField(
          onChanged: (String s) {
            inputtext = s;
          },
          controller: TextEditingController(text: inputtext),
          decoration:
              InputDecoration(labelText: title, border: OutlineInputBorder()),
          maxLength: maxlength,
          maxLengthEnforcement: maxlength == null
              ? MaxLengthEnforcement.none
              : MaxLengthEnforcement.enforced,
          keyboardType: keyboardType,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                getTextPrimary(context),
              ),
            ),
            child: Text(getString(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(inputtext);
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                getTextPrimary(context),
              ),
            ),
            child: Text(getString(context).set),
          )
        ],
      );
    },
  );
}

Widget getHeadedCardView({
  required IconData iconData,
  required String title,
  required List<Widget> content,
  Widget? bottom,
}) {
  List<Widget> widgetlist = [
    Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 12.0, bottom: 12.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 18.0,
              color: Colors.grey,
            ),
            Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        )),
  ];
  widgetlist.addAll(content);
  if (bottom != null) widgetlist.add(bottom);
  return Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgetlist,
    ),
  );
}

Widget getHeadedCardViewSingle({
  required IconData iconData,
  required String title,
  required Widget content,
  Widget? bottom,
}) {
  List<Widget> widgetlist = [
    Padding(
      padding: const EdgeInsets.only(
          left: 16.0, top: 12.0, bottom: 12.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 18.0,
            color: Colors.grey,
          ),
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    ),
  ];
  widgetlist.add(content);
  if (bottom != null) widgetlist.add(bottom);
  return Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgetlist,
    ),
  );
}

class LabeledIconButton extends StatelessWidget {
  final String name;
  final IconData iconData;
  final bool selected;
  final VoidCallback onTap;
  LabeledIconButton({
    required this.name,
    required this.iconData,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selected ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(
            left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
        height: 72.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 32.0,
              color: selected ? Colors.red : Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              child: Text(
                name,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? Colors.red : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledIconButtonSmall extends StatelessWidget {
  final String name;
  final IconData iconData;
  final bool selected;
  final VoidCallback onTap;
  LabeledIconButtonSmall({
    required this.name,
    required this.iconData,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: selected ? null : onTap,
        child: Container(
          margin: const EdgeInsets.only(
              left: 2.0, right: 2.0, top: 4.0, bottom: 4.0),
          height: 62.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 24.0,
                color: selected ? Colors.red : Colors.grey,
              ),
              Container(
                margin: const EdgeInsets.only(top: 2.0),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? Colors.red : Colors.grey),
                ),
              ),
            ],
          ),
        ));
  }
}

class MyAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  MyAppHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBar(
          centerTitle: true,
          title: Text(title ?? '-'),
          elevation: 0.0,
        ),
        Divider(
          height: 1.0,
          color: getDividerColor(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(57.0);
}

Widget getEmptyView({String? title, IconData? icon}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon ?? Icons.wb_sunny,
          size: 48.0,
        ),
        Padding(padding: const EdgeInsets.all(6.0)),
        Text(
          title ?? '-',
          style: TextStyle(fontSize: 17.0),
        )
      ],
    ),
  );
}

DateTime fromTimeOfDay(TimeOfDay time) {
  return DateTime(0, 0, 0, time.hour, time.minute);
}

Brightness autoBrightness() {
  TimeOfDay startDay = TimeOfDay(hour: 7, minute: 00);
  TimeOfDay startEvening = TimeOfDay(hour: 19, minute: 00);
  TimeOfDay now = TimeOfDay.now();
  if (fromTimeOfDay(now).isAfter(fromTimeOfDay(startDay)) &&
      fromTimeOfDay(now).isBefore(fromTimeOfDay(startEvening))) {
    return Brightness.light;
  } else {
    return Brightness.dark;
  }
}

Widget? selectedView(bool selected) {
  return selected
      ? Icon(
          Icons.done,
          color: Colors.green,
        )
      : null;
}

void popNavigatorBy(BuildContext context, {required String text}) {
  Navigator.popUntil(context, (Route predicate) {
    return (predicate.settings.name?.contains(text) ?? false) == false;
  });
}

void showSheet(
    {required BuildContext context,
    required Widget child,
    required String? title,
    List<Widget>? actions}) {
  showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return clearAppTheme(
            context: context,
            child: Opacity(
              opacity: 1.0,
              child: Material(
                color: getSheetColor(context),
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 6.0,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 4.0,
                        width: MediaQuery.of(context).size.width / 6,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            color: Colors.grey[500]),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        title ?? '-',
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500]),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    child,
                    SizedBox(
                      height: 6.0,
                    ),
                    actions != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: actions,
                          )
                        : SizedBox(
                            height: 0.0,
                          ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ));
      });
}

ValueNotifier<bool?> showPermissionStateSheet({required BuildContext context}) {
  ValueNotifier<bool?> mNotifier = ValueNotifier(null);
  showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return clearAppTheme(
            context: context,
            child: ValueListenableBuilder<bool?>(
                valueListenable: mNotifier,
                builder: (context, data, _) {
                  return Opacity(
                    opacity: 1.0,
                    child: Material(
                        color: getSheetColor(context),
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 6.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width / 6,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            Center(
                              child: data == null
                                  ? CircularProgressIndicator()
                                  : (data == true
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 48.0,
                                        )
                                      : Icon(
                                          Icons.lock,
                                          color: Colors.redAccent,
                                          size: 48.0,
                                        )),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                data == null
                                    ? getString(context).pleasewait
                                    : (data == true
                                        ? getString(context).permissionretrieved
                                        : getString(context)
                                            .nopermissionretrieved),
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                          ],
                        )),
                  );
                }));
      });
  return mNotifier;
}

ValueNotifier<ResultItem> showResultStateSheet(
    {required BuildContext context, double fontSize = 19.0}) {
  ValueNotifier<ResultItem> mNotifier =
      ValueNotifier(ResultItem(loading: true));
  showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return clearAppTheme(
            context: context,
            child: ValueListenableBuilder<ResultItem>(
                valueListenable: mNotifier,
                builder: (context, data, _) {
                  return Opacity(
                    opacity: 1.0,
                    child: Material(
                        color: getSheetColor(context),
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 6.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width / 6,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            Center(
                              child: data.loading == true
                                  ? CircularProgressIndicator()
                                  : (data.iconData != null
                                      ? Icon(
                                          data.iconData,
                                          color: data.color,
                                          size: 48.0,
                                        )
                                      : Icon(
                                          Icons.help_outline,
                                          color: Colors.orange,
                                          size: 48.0,
                                        )),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  data.text == null
                                      ? getString(context).pleasewait
                                      : (data.text ?? getString(context).error),
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                          ],
                        )),
                  );
                }));
      });
  return mNotifier;
}

class ResultItem {
  String? text;
  bool? loading;
  IconData? iconData;
  Color color;
  ResultItem({
    this.text,
    this.loading = true,
    this.iconData,
    this.color = Colors.blueGrey,
  });
}

void showLoadingStateSheet({
  required BuildContext context,
  required ValueNotifier<bool?> sheetUpdate,
}) {
  showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return clearAppTheme(
            context: context,
            child: ValueListenableBuilder<bool?>(
                valueListenable: sheetUpdate,
                builder: (context, data, _) {
                  return Opacity(
                    opacity: 1.0,
                    child: Material(
                        color: getSheetColor(context),
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 6.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width / 6,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            Center(
                              child: data == null
                                  ? CircularProgressIndicator()
                                  : (data == true
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 48.0,
                                        )
                                      : Icon(
                                          Icons.error,
                                          color: Colors.redAccent,
                                          size: 48.0,
                                        )),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                data == null
                                    ? getString(context).pleasewait
                                    : (data == true
                                        ? getString(context).done
                                        : getString(context).failed),
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                          ],
                        )),
                  );
                }));
      });
}

ValueNotifier<bool?> showLoadingStateSheetFull({
  required BuildContext context,
}) {
  ValueNotifier<bool?> sheetUpdate = ValueNotifier(null);
  showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      routeSettings: RouteSettings(name: 'loadingsheet'),
      context: context,
      builder: (BuildContext context) {
        return clearAppTheme(
            context: context,
            child: ValueListenableBuilder<bool?>(
                valueListenable: sheetUpdate,
                builder: (context, data, _) {
                  if (data == true) {
                    Future.delayed(Duration(seconds: 1), () {
                      popNavigatorBy(context, text: 'loadingsheet');
                    });
                  }
                  return Opacity(
                    opacity: 1.0,
                    child: Material(
                        color: getSheetColor(context),
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 6.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width / 6,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            Center(
                              child: data == null
                                  ? CircularProgressIndicator()
                                  : (data == true
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 48.0,
                                        )
                                      : Icon(
                                          Icons.error,
                                          color: Colors.redAccent,
                                          size: 48.0,
                                        )),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                data == null
                                    ? getString(context).pleasewait
                                    : (data == true
                                        ? getString(context).done
                                        : getString(context).failed),
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                          ],
                        )),
                  );
                }));
      });
  return sheetUpdate;
}

Future<T?> showSheetBuilder<T>({
  required BuildContext context,
  required WidgetBuilder child,
  String? title,
  WidgetListBuilder? actions,
  String? routname,
}) {
  return showModalBottomSheet<T>(
    constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    context: context,
    builder: (BuildContext sheetcontext) {
      return clearAppTheme(
          context: sheetcontext,
          child: Opacity(
            opacity: 1.0,
            child: Material(
              color: getSheetColor(sheetcontext),
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 6.0,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 4.0,
                      width: MediaQuery.of(sheetcontext).size.width / 6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  if (title != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500]),
                      ),
                    ),
                  if (title != null)
                    SizedBox(
                      height: 12.0,
                    ),
                  child(sheetcontext),
                  SizedBox(
                    height: 6.0,
                  ),
                  actions != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: actions(sheetcontext),
                        )
                      : SizedBox(
                          height: 0.0,
                        ),
                  SizedBox(
                    height: 6.0,
                  ),
                ],
              ),
            ),
          ));
    },
    routeSettings: RouteSettings(name: routname),
  );
}

Widget getSheetText(BuildContext context, String? text) {
  return Align(
    alignment: Alignment.topCenter,
    child: Text(
      text ?? '-',
      style: TextStyle(
          fontSize: 19.0, fontWeight: FontWeight.w400, color: Colors.grey[500]),
    ),
  );
}

void showConfirmationDialog(
    {required BuildContext context,
    required String title,
    required VoidCallback onConfirm,
    required String action,
    bool? warning,
    required RichText richtext,
    String? warningtext}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return clearAppTheme(
            context: context,
            child: AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  richtext,
                  SizedBox(
                    height: 8.0,
                  ),
                  warning == true
                      ? Card(
                          color: Colors.redAccent,
                          child: ListTile(
                            leading: Icon(Icons.warning),
                            title: Text(warningtext ??
                                'Du kannst dies nicht rückgäng machen!'),
                          ),
                        )
                      : SizedBox(
                          height: 0.0,
                        ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      getTextColor(getBackgroundColor(context)),
                    ),
                  ),
                  child: Text(getString(context).cancel.toUpperCase()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                  child: Text(action.toUpperCase()),
                ),
              ],
            ));
      });
}

Future<bool?> showConfirmDialog(
    {required BuildContext context,
    required String title,
    String? action,
    RichText? richtext,
    String? warningtext}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              richtext ?? nowidget(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  getClearTextColor(context),
                ),
              ),
              child: Text(getString(context).cancel.toUpperCase()),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              color: Colors.redAccent,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Text((action ?? title).toUpperCase()),
            ),
          ],
        );
      });
}

Future<void> showDetailSheetBuilder(
    {required BuildContext context,
    required WidgetBuilder body,
    String? routname}) {
  return showModalBottomSheet(
    constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    context: context,
    builder: (BuildContext sheetcontext) {
      return clearAppTheme(
          context: sheetcontext,
          child: Opacity(
            opacity: 1.0,
            child: Material(
              color: getSheetColor(sheetcontext),
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 6.0,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 4.0,
                      width: MediaQuery.of(sheetcontext).size.width / 6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  body(sheetcontext),
                ],
              ),
            ),
          ));
    },
    routeSettings: RouteSettings(name: routname),
  );
}

Widget nowidget() => Container();

Widget loadedView() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

class LoadAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ColoredCircleText extends StatelessWidget {
  final Color? color;
  final String? text;
  final double radius, textsize;
  const ColoredCircleText(
      {this.color, this.text, this.radius = 22.0, this.textsize = 17.0});

  @override
  Widget build(BuildContext context) {
    Color finalcolor = color ?? getAccentColor(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: getEventualBorder(context, finalcolor),
          width: 0.5,
        ),
        color: finalcolor,
      ),
      width: radius * 2,
      height: radius * 2,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Text(
            text ?? '-',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: getTextColor(finalcolor),
                fontSize: textsize,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class ColoredCircleIcon extends StatelessWidget {
  final Color? color;
  final Icon? icon;
  final double radius;
  const ColoredCircleIcon({this.color, this.icon, this.radius = 22.0});

  @override
  Widget build(BuildContext context) {
    Color finalcolor = color ?? getAccentColor(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: getEventualBorder(context, finalcolor),
          width: 0.5,
        ),
        color: finalcolor,
      ),
      width: radius * 2,
      height: radius * 2,
      child: Center(
        child: icon,
      ),
    );
  }
}

Stream<TwoObjects<T1?, T2?>> getMergedStream<T1, T2>(
    Stream<T1?> stream1, Stream<T2?> stream2) {
  StreamController<TwoObjects<T1?, T2?>> newcontroller = StreamController();
  T1? data1;
  T2? data2;
  var listenstream1 = stream1.listen((data) {
    data1 = data;
    newcontroller.add(TwoObjects(item: data1, item2: data2));
  });
  var listenstream2 = stream2.listen((data) {
    data2 = data;
    newcontroller.add(TwoObjects(item: data1, item2: data2));
  });
  newcontroller.onCancel = () {
    listenstream1.cancel();
    listenstream2.cancel();
  };
  return newcontroller.stream;
}

Stream<ThreeObjects<T1?, T2?, T3?>> getThreeMergedStream<T1, T2, T3>(
    Stream<T1?> stream1, Stream<T2?> stream2, Stream<T3?> stream3) {
  StreamController<ThreeObjects<T1?, T2?, T3?>> newcontroller =
      StreamController();
  T1? data1;
  T2? data2;
  T3? data3;
  var listenstream1 = stream1.listen((data) {
    data1 = data;
    newcontroller.add(ThreeObjects(item: data1, item2: data2, item3: data3));
  });
  var listenstream2 = stream2.listen((data) {
    data2 = data;
    newcontroller.add(ThreeObjects(item: data1, item2: data2, item3: data3));
  });
  var listenstream3 = stream3.listen((data) {
    data3 = data;
    newcontroller.add(ThreeObjects(item: data1, item2: data2, item3: data3));
  });
  newcontroller.onCancel = () {
    listenstream1.cancel();
    listenstream2.cancel();
    listenstream3.cancel();
  };
  return newcontroller.stream;
}

class QRCodeViewPublicCode extends StatelessWidget {
  final String? publiccode;

  QRCodeViewPublicCode({required this.publiccode});
  @override
  Widget build(BuildContext context) {
    return publiccode == null
        ? Container()
        : InkWell(
            child: QrImage(
              data: publiccode!,
              size: 112.0,
              foregroundColor: getTextColor(getBackgroundColor(context)),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      getString(context).qrcode,
                      textAlign: TextAlign.center,
                    ),
                    content: Builder(builder: (context) {
                      double value = MediaQuery.of(context).size.width - 130;
                      return SizedBox(
                        height: value,
                        width: value,
                        child: Container(
                          child: QrImage2(
                            data: publiccode!,
                            size: value,
                            foregroundColor:
                                getTextColor(getBackgroundColor(context)),
                          ),
                        ),
                      );
                    }),
                    contentPadding:
                        EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(getString(context).cancel))
                    ],
                  );
                },
              );
            },
          );
  }
}

String toShortNameLength(BuildContext context, String? text) {
  int length = getConfigurationData(context).shortname_length;
  if (text == null) return '-';
  if (length == 0) return text;
  return text.substring(0, text.length > length ? length : text.length);
}
