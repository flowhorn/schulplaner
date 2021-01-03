import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/groups/src/models/place.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class PlaceList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;
  PlaceList({@required this.plannerDatabase});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Place>>(
        stream: plannerDatabase.places.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Place> itemlist = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                Place item = itemlist[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    children: <Widget>[
                      Text(getString(context).address +
                          ": " +
                          (item.address ?? "-")),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  isThreeLine: true,
                  onTap: () {
                    showPlaceDetail(
                        context: context,
                        plannerdatabase: plannerDatabase,
                        placeid: item.placeid);
                  },
                );
              },
              itemCount: itemlist.length,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushWidget(context, NewPlaceView(database: plannerDatabase));
        },
        icon: Icon(Icons.add),
        label: Text(getString(context).newplace),
      ),
    );
  }
}

class NewPlaceView extends StatelessWidget {
  final PlannerDatabase database;

  bool changedValues = false;
  final bool editMode;
  final String editplaceid;

  Place data;
  ValueNotifier<Place> notifier;
  NewPlaceView(
      {@required this.database, this.editMode = false, this.editplaceid}) {
    data = editMode
        ? database.places.getItem(editplaceid)
        : Place(placeid: database.dataManager.generatePlaceId());
    notifier = ValueNotifier(data);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<Place>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Scaffold(
                appBar: MyAppHeader(
                    title: editMode
                        ? getString(context).editplace
                        : getString(context).newplace),
                body: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    FormHeader(getString(context).general),
                    FormTextField(
                      text: data.name,
                      valueChanged: (newtext) {
                        data.name = newtext;
                        changedValues = true;
                      },
                      labeltext: getString(context).name,
                    ),
                    FormSpace(16.0),
                    FormTextField(
                      text: data.address,
                      valueChanged: (newtext) {
                        data.address = newtext;
                        changedValues = true;
                      },
                      iconData: Icons.map,
                      labeltext: getString(context).address,
                    ),
                    FormSpace(16.0),
                    FormDivider(),
                    FormSpace(64.0),
                  ],
                )),
                floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      if (data.validate()) {
                        if (editMode) {
                          database.dataManager.ModifyPlace(data);
                          Navigator.pop(context);
                        } else {
                          database.dataManager.AddPlace(data);
                          Navigator.pop(context);
                        }
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

Future<void> showPlaceDetail(
    {@required BuildContext context,
    @required PlannerDatabase plannerdatabase,
    @required String placeid}) async{
  await showDetailSheetBuilder(
      context: context,
      body: (BuildContext context) {
        return StreamBuilder<Place>(
            stream: plannerdatabase.places.getItemStream(placeid),
            builder: (BuildContext context, snapshot) {
              Place item = snapshot.data;
              if (item == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, item.name),
                  FormSpace(12.0),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text(item.address ?? "-"),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      RButton(
                          text: getString(context).navigate,
                          onTap: () {
                            if (item.address != null) {
                              launch("geo:0,0?:" + item.address);
                            }
                          }),
                      RButton(
                          text: getString(context).more,
                          onTap: () {
                            showSheetBuilder(
                                context: context,
                                child: (context) {
                                  return Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text(getString(context).edit),
                                        onTap: () {
                                          Navigator.pop(context);
                                          pushWidget(
                                              context,
                                              NewPlaceView(
                                                database: plannerdatabase,
                                                editMode: true,
                                                editplaceid: item.placeid,
                                              ));
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete_outline),
                                        title: Text(getString(context).delete),
                                        onTap: () {
                                          showConfirmDialog(
                                                  context: context,
                                                  title:
                                                      getString(context).delete,
                                                  action:
                                                      getString(context).delete,
                                                  richtext: null)
                                              .then((result) {
                                            if (result == true) {
                                              plannerdatabase.dataManager
                                                  .DeletePlace(item);
                                              popNavigatorBy(context,
                                                  text: "placeid");
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                                title: getString(context).more,
                                routname: "placeidmore");
                          },
                          iconData: Icons.more_horiz),
                    ],
                  )
                ],
              );
            });
      },
      routname: "placeidview");
}
