import 'package:bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/References.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/models/planner.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/ManagePlanner_SubLogic.dart';

import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

List<Color> colorList = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

class ManagePlannerView extends StatelessWidget {
  const ManagePlannerView();
  @override
  Widget build(BuildContext context) {
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).manageplanner,
      ),
      body: StreamBuilder<LoadAllPlannerStatus>(
          stream: plannerLoaderBloc.loadAllPlannerStatus,
          builder: (context, snapshot) {
            final loadAllPlannerStatus = snapshot.data;
            if (loadAllPlannerStatus != null) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.archive,
                            color: getTextColor(getAccentColor(context)),
                          ),
                          backgroundColor: getAccentColor(context),
                        ),
                        title: Text(getString(context).archivedplanners),
                        trailing: FlatButton(
                          onPressed: () {
                            pushWidget(context, ArchivedPlanner());
                          },
                          child: Text(getString(context).view.toUpperCase()),
                          textColor: getAccentColor(context),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: OrderableExample(
                    plannerLoaderBloc,
                    loadAllPlannerStatus,
                    (context, Planner it, _) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 5.0, bottom: 0.0),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.reorder),
                                title: Text(it.name),
                                trailing: it.id ==
                                        (loadAllPlannerStatus.getPlanner()?.id)
                                    ? RButton(
                                        text: getString(context).selected,
                                        onTap: null,
                                        enabled: false,
                                        iconData: Icons.done,
                                        disabledColor: Colors.green)
                                    : RButton(
                                        text: getString(context).select,
                                        onTap: () {
                                          plannerLoaderBloc
                                              .setActivePlanner(it.id);
                                        },
                                        enabled: true,
                                        iconData: Icons.done,
                                        disabledColor: Colors.green),
                              ),
                              Row(
                                children: <Widget>[
                                  FlatButton.icon(
                                      onPressed: () {
                                        pushWidget(
                                            context,
                                            NewPlannerView(
                                              plannerLoaderBloc:
                                                  plannerLoaderBloc,
                                              editmode: true,
                                              plannerid: it.id,
                                            ));
                                      },
                                      icon: Icon(Icons.edit),
                                      label: Text(getString(context).edit)),
                                  FlatButton.icon(
                                      onPressed: () {
                                        showSheet(
                                            context: context,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: Icon(Icons.archive),
                                                  title: Text(getString(context)
                                                      .archive),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    plannerLoaderBloc
                                                        .archivePlanner(
                                                            it, true);
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.content_copy),
                                                  title: Text(bothlang(context,
                                                      de: "Kopie erstellen",
                                                      en: "Create a copy")),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    plannerLoaderBloc
                                                        .createCopy(it);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                      Icons.delete_forever),
                                                  title: Text(getString(context)
                                                      .delete),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showConfirmationDialog(
                                                        context: context,
                                                        title:
                                                            getString(context)
                                                                .delete,
                                                        action:
                                                            getString(context)
                                                                .delete,
                                                        onConfirm: () {
                                                          plannerLoaderBloc
                                                              .deletePlanner(
                                                                  it);
                                                        },
                                                        richtext: RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              //todo(th3ph4nt0m): get this in 1 single TextSpan and add English translation
                                                              TextSpan(
                                                                  text:
                                                                      "Möchtest du den Planer "),
                                                              TextSpan(
                                                                  text: it.name,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text:
                                                                      " löschen?")
                                                            ])),
                                                        warning: true);
                                                  },
                                                ),
                                              ],
                                            ),
                                            title: it.name);
                                      },
                                      icon: Icon(Icons.more_horiz),
                                      label: Text(getString(context).more)),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    key: Key(loadAllPlannerStatus.hashCode.toString()),
                  )),
                ],
                mainAxisSize: MainAxisSize.max,
              );
              /*
          return ListView(
              children: [
                Padding(padding: EdgeInsets.all(4.0), child: Card(child: ListTile(leading: CircleAvatar(child: Icon(Icons.archive),backgroundColor: getAccentColor(context),),title: Text("Archiv"),
                  trailing: FlatButton(onPressed: (){}, child: Text("Ansehen".toUpperCase()), textColor: getAccentColor(context),),
                  subtitle: Text("3 archivierte Planer"),
                ),),),
              ]..addAll((loadAllPlannerStatus.getAllPlanner().isNotEmpty
                  ? loadAllPlannerStatus
                  .getAllPlanner()
                  .map<Widget>((it){
                return Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 0.0), child: Card(child: Column(children: <Widget>[
                  ListTile(
                    title: Text(it.name),
                    trailing: it.id == loadAllPlannerStatus.getPlanner().id ? Icon(Icons.done, color: Colors.green,) :null,
                  ),
                  Row(children: <Widget>[
                    FlatButton.icon(onPressed: it.id == loadAllPlannerStatus.getPlanner().id ?null : (){
                      loadAllPlanner.setActivePlanner(it.id);
                    }, icon: Icon(Icons.done), label: Text("Auswählen"),),
                    FlatButton.icon(onPressed: (){}, icon: Icon(Icons.edit), label: Text("Bearbeiten")),
                    FlatButton.icon(onPressed: (){
                      showSheet(context: context, child: Column(children: <Widget>[
                        ListTile(leading: Icon(Icons.archive),title: Text("Archivieren"),onTap: (){},),
                        ListTile(leading: Icon(Icons.delete_forever),title: Text("Löschen"),onTap: (){},),

                      ],), title: it.name);

                    }, icon: Icon(Icons.more_horiz), label: Text("Mehr")),
                  ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),

                ],),),);

              })
                  .toList()
                  : [
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text("Keine Planer vorhanden"),
                )
              ]))
          );
           */
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            pushWidget(
                context,
                NewPlannerView(
                  plannerLoaderBloc: plannerLoaderBloc,
                ));
          },
          icon: Icon(Icons.add),
          label: Text(getString(context).newplanner)),
    );
  }
}

class ArchivedPlanner extends StatelessWidget {
  ArchivedPlanner();
  @override
  Widget build(BuildContext context) {
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).archivedplanners),
      body: StreamBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((data) {
                final planner = Planner.fromData(data.data());
                return Padding(
                  padding: EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 5.0, bottom: 0.0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(planner.name),
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton.icon(
                                onPressed: () {
                                  pushWidget(
                                      context,
                                      NewPlannerView(
                                          plannerLoaderBloc: plannerLoaderBloc,
                                          editmode: true,
                                          previousplanner: planner));
                                },
                                icon: Icon(Icons.edit),
                                label: Text(getString(context).edit)),
                            FlatButton.icon(
                                onPressed: () {
                                  showSheet(
                                      context: context,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.unarchive),
                                            title: Text(
                                                getString(context).unarchive),
                                            onTap: () {
                                              Navigator.pop(context);
                                              plannerLoaderBloc.archivePlanner(
                                                  planner, false);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.delete_forever),
                                            title:
                                                Text(getString(context).delete),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showConfirmationDialog(
                                                  context: context,
                                                  title:
                                                      getString(context).delete,
                                                  action:
                                                      getString(context).delete,
                                                  onConfirm: () {
                                                    plannerLoaderBloc
                                                        .deletePlanner(planner);
                                                  },
                                                  richtext: RichText(
                                                    text: TextSpan(children: [
                                                      //todo(th3ph4nt0m): Get this in 1 single TextSpan and add English translation
                                                      TextSpan(
                                                          text:
                                                              "Möchtest du den Planer "),
                                                      TextSpan(
                                                          text: planner.name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text:
                                                              " ${getString(context).delete}?")
                                                    ]),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  warning: true);
                                            },
                                          ),
                                        ],
                                      ),
                                      title: planner.name);
                                },
                                icon: Icon(Icons.more_horiz),
                                label: Text(getString(context).more)),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: getPlannerRef(plannerLoaderBloc.currentUserId)
            .where("deleted", isEqualTo: false)
            .where("archived", isEqualTo: true)
            .snapshots(),
      ),
    );
  }
}

class NewPlannerView extends StatefulWidget {
  final PlannerLoaderBloc plannerLoaderBloc;
  final bool editmode;
  final String plannerid;
  final Planner previousplanner;
  final bool activateplanner;
  NewPlannerView(
      {@required this.plannerLoaderBloc,
      this.plannerid,
      this.editmode = false,
      this.previousplanner,
      this.activateplanner = false});
  @override
  State<StatefulWidget> createState() => _NewPlannerViewState(
      plannerLoaderBloc: plannerLoaderBloc,
      plannerid: plannerid,
      editmode: editmode,
      previousplanner: previousplanner);
}

class _NewPlannerViewState extends State<NewPlannerView> {
  final PlannerLoaderBloc plannerLoaderBloc;
  final bool editmode;
  final String plannerid;
  _NewPlannerViewState(
      {@required this.plannerLoaderBloc,
      this.plannerid,
      this.editmode = false,
      Planner previousplanner}) {
    if (editmode) {
      planner = previousplanner ??
          plannerLoaderBloc.loadAllPlannerStatusValue.plannermap[plannerid];
    } else {
      planner = Planner(
          id: getPlannerRef(plannerLoaderBloc.currentUserId).doc().id,
          uid: plannerLoaderBloc.currentUserId.uid,
          name: "");
    }
  }

  Planner planner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppHeader(
            title: editmode
                ? getString(context).editplanner
                : getString(context).newplanner),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormSpace(8.0),
              FormTextField(
                valueChanged: (newtext) {
                  planner = planner.copyWith(name: newtext);
                },
                text: planner?.name ?? "",
                labeltext: getString(context).name,
                iconData: Icons.short_text,
                autofocus: true,
              ),
              FormSpace(8.0),
              FormDivider(),
              FormSpace(64.0),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (planner.validate()) {
                if (editmode) {
                  plannerLoaderBloc.editPlanner(planner);
                } else {
                  plannerLoaderBloc.createPlanner(planner);
                  if (widget?.activateplanner ?? false) {
                    plannerLoaderBloc.setActivePlanner(planner.id);
                  }
                }
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.done),
            label: Text(getString(context).done)));
  }
}
