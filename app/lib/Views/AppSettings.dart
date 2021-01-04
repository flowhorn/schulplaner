import 'package:bloc/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schulplaner8/Data/userdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/user_database_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/app_base/src/models/configuration_data.dart';
import 'package:schulplaner8/profile/user_image_view.dart';
import 'package:schulplaner8/settings/src/about_page/about_page.dart';
import 'package:schulplaner8/settings/src/pages/edit_apperance_page.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldRest/Calendar.dart';
import 'package:schulplaner8/Views/AppState.dart';
import 'package:schulplaner8/Views/Help.dart';
import 'package:schulplaner8/Views/ManagePlanner.dart';
import 'package:schulplaner8/Views/MyProfile.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/Views/SchoolPlanner/PlannerSettings.dart';
import 'package:schulplaner8/Views/settings/pages/settings_privacy_page.dart';
import 'package:schulplaner8/models/user.dart';

import 'NavigationActions.dart';
import 'authentification/authentification_methodes.dart';

class AppSettingsView extends StatelessWidget {
  AppSettingsView();

  @override
  Widget build(BuildContext context) {
    final userDatabaseBloc = BlocProvider.of<UserDatabaseBloc>(context);
    final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
    final plannerLoaderBloc = BlocProvider.of<PlannerLoaderBloc>(context);
    final plannerDatabaseBloc = BlocProvider.of<PlannerDatabaseBloc>(context);
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).settings,
      ),
      body: ListView(
        children: <Widget>[
          FormSection(
              title: getString(context).general,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Text(getString(context).appearance),
                    onTap: () {
                      openEditAppearancePage(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.adjust),
                    title: Text(getString(context).configure),
                    onTap: () {
                      pushWidget(
                          context,
                          AppConfigurationView(
                            appSettingsBloc: appSettingsBloc,
                            userDatabase: userDatabaseBloc.userDatabase,
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text(getString(context).manageplanner),
                    enabled: userDatabaseBloc.userDatabase != null,
                    onTap: userDatabaseBloc.userDatabase != null
                        ? () {
                            pushWidget(context, ManagePlannerView());
                          }
                        : null,
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text(getString(context).language +
                        ': ' +
                        (getLanguage(
                              context,
                              getAppSettingsData(context).languagecode,
                            )?.name ??
                            '-')),
                    onTap: () {
                      selectItem<SimpleItem>(
                          context: context,
                          items: availableLanguages(context),
                          builder: (BuildContext context, SimpleItem item) {
                            final languageCode =
                                getAppSettingsData(context).languagecode;
                            return ListTile(
                              leading: item.iconData != null
                                  ? Icon(item.iconData)
                                  : null,
                              title: Text(
                                item.name ?? '-',
                              ),
                              trailing: item.id == languageCode
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  : null,
                              onTap: item.id == languageCode
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      final bloc =
                                          BlocProvider.of<AppSettingsBloc>(
                                              context);
                                      final newData = bloc.currentValue
                                          .copyWith(languagecode: item.id);

                                      bloc.setAppSettings(newData);
                                    },
                              enabled: item.id != languageCode,
                            );
                          });
                    },
                  ),
                ],
              )),
          //FormDivider(),

          FormSection(
            title: plannerLoaderBloc.loadAllPlannerStatusValue
                    ?.getPlanner()
                    ?.name ??
                getString(context).apptitle,
            child: Builder(builder: (BuildContext context) {
              if (plannerDatabaseBloc.plannerDatabase == null ||
                  plannerDatabaseBloc.plannerDatabase.isClosed() ||
                  plannerDatabaseBloc.plannerDatabase.plannerid !=
                      plannerLoaderBloc.loadAllPlannerStatusValue
                          ?.getPlanner()
                          ?.id) {
                return ListTile(
                  title: Text(
                    getString(context).functionnotavailable,
                    textAlign: TextAlign.center,
                  ),
                  enabled: false,
                );
              } else {
                return PlannerSettings();
              }
            }),
          ),
          //FormDivider(),

          FormSection(
            title: getString(context).further,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text(getString(context).privacy),
                  onTap: () {
                    pushWidget(context, PrivacyView());
                  },
                ),
                ListTile(
                    leading: Icon(Icons.help),
                    title: Text(getString(context).help),
                    onTap: () {
                      pushWidget(context, HelpView());
                    }),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(getString(context).about),
                  onTap: () {
                    pushWidget(context, AboutPage());
                  },
                ),
              ],
            ),
          ),

          FormSection(
            title: getString(context).registration,
            child: Builder(builder: (BuildContext context) {
              if (userDatabaseBloc.userDatabase == null) {
                return ListTile(
                  title: Text(
                    getString(context).functionnotavailable,
                    textAlign: TextAlign.center,
                  ),
                  enabled: false,
                );
              } else {
                return Column(
                  children: <Widget>[
                    DataDocumentWidget<UserProfile>(
                        allowNull: true,
                        package: userDatabaseBloc.userDatabase.userprofile,
                        builder: (context, data) {
                          return ListTile(
                            leading: UserImageView(
                              userProfile: data,
                              size: 36.0,
                            ),
                            title: Text(
                                data?.name ?? getString(context).anonymoususer),
                            trailing: RButton(
                              onTap: () {
                                pushWidget(context, MyProfile());
                              },
                              text:
                                  getString(context).gotoprofile.toUpperCase(),
                            ),
                          );
                        }),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text(getString(context).signinmethodes),
                      onTap: () {
                        pushWidget(context, AuthenticationMethodes());
                      },
                    ),
                    SizedBox(
                        height: 52.0,
                        width: double.infinity,
                        child: FlatButton.icon(
                          icon: Icon(Icons.exit_to_app),
                          label: Text(
                            getString(context).logout,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            showConfirmationDialog(
                                context: context,
                                title: getString(context).logout,
                                onConfirm: () {
                                  firebase_auth.FirebaseAuth.instance.signOut();
                                  try {
                                    GoogleSignIn.standard().signOut();
                                  } catch (e) {
                                    print(e);
                                  }
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                action: getString(context).confirm,
                                richtext: RichText(
                                    text: TextSpan(
                                        text: bothlang(context,
                                            de:
                                                'Möchtest du dich wirklich ausloggen?',
                                            en:
                                                'Do you really want to log out?'))),
                                warning: true,
                                warningtext: bothlang(context,
                                    de: 'Wenn du keine Anmeldemethode eingerichtet hast, gehen alle Daten verloren!',
                                    en: 'If you did not set up a login method, all data will get lost.'));
                          },
                        )),
                  ],
                  mainAxisSize: MainAxisSize.min,
                );
              }
            }),
          ),
          FormSpace(32.0),
        ],
      ),
    );
  }
}

List<SimpleItem> availableLanguages(BuildContext context) {
  return [
    SimpleItem(
        id: null,
        name: getString(context).automatic,
        iconData: Icons.brightness_auto),
    SimpleItem(
      id: 'de',
      name: 'Deutsch',
    ),
    SimpleItem(
      id: 'en',
      name: 'English',
    ),
  ];
}

SimpleItem getLanguage(BuildContext context, String languagecode) {
  return availableLanguages(context)
          .firstWhere((it) => it.id == languagecode) ??
      availableLanguages(context)[0];
}

class AppConfigurationView extends StatelessWidget {
  final AppSettingsBloc appSettingsBloc;
  final UserDatabase userDatabase;
  AppConfigurationView(
      {@required this.appSettingsBloc, @required this.userDatabase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderAdvanced(
        title: Text(getString(context).configure),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.text_rotation_angledown),
            title: Text(getString(context).general),
            onTap: () {
              push_SubWidget(
                  context, getSub_General(), getString(context).general);
            },
          ),
          ListTile(
            leading: Icon(Icons.navigation),
            title: Text(getString(context).navigation),
            onTap: () {
              push_SubWidget(
                  context, getSub_Navigation(), getString(context).favorites);
            },
          ),
          ListTile(
            leading: Icon(Icons.today),
            title: Text(getString(context).timetable),
            onTap: () {
              push_SubWidget(
                  context, getSub_Timetable(), getString(context).timetable);
            },
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text(getString(context).timeline),
            onTap: () {
              push_SubWidget(
                  context, getSub_Timeline(), getString(context).timeline);
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(getString(context).calendar),
            onTap: () {
              push_SubWidget(
                  context, getSub_Calendar(), getString(context).calendar);
            },
          ),
          ListTile(
            leading: Icon(Icons.developer_board),
            title: Text(getString(context).advanced),
            onTap: () {
              push_SubWidget(
                  context, getSub_Advanced(), getString(context).advanced);
            },
          ),
        ],
      ),
    );
  }

  void push_SubWidget(BuildContext context, Widget child, String title) {
    pushWidget(
        context,
        Scaffold(
          appBar: MyAppHeader(
            title: title,
          ),
          body: child,
        ));
  }

  Widget getSub_General() {
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        final configurationData = snapshot.data.configurationData;
        return ListView(
          children: <Widget>[
            ListTile(
              title: Text(getString(context).amount_of_letters_forshortname),
              subtitle: Text(configurationData.shortname_length == 0
                  ? getString(context).individual
                  : (configurationData.shortname_length.toString() +
                      ' ' +
                      getString(context).letters)),
              onTap: () {
                selectItem(
                    context: context,
                    items: buildIntList(4, start: 0),
                    builder: (context, item) {
                      return ListTile(
                        title: Text(item == 0
                            ? getString(context).individual
                            : (item.toString() +
                                ' ' +
                                getString(context).letters)),
                        onTap: () {
                          Navigator.pop(context);
                          appSettingsBloc.setAppConfiguration(configurationData
                              .copyWith(shortname_length: item));
                        },
                      );
                    });
              },
            ),
            ListTile(
              title: Text(getString(context).amount_of_days_home),
              subtitle: Text((configurationData.general_daysinhome.toString() +
                  ' ' +
                  getString(context).days_normal)),
              onTap: () {
                selectItem(
                    context: context,
                    items: buildIntList(7, start: 2),
                    builder: (context, item) {
                      return ListTile(
                        title: Text((item.toString() +
                            ' ' +
                            getString(context).days_normal)),
                        onTap: () {
                          Navigator.pop(context);
                          appSettingsBloc.setAppConfiguration(configurationData
                              .copyWith(general_daysinhome: item));
                        },
                      );
                    });
              },
            ),
          ],
        );
      },
    );
  }

  Widget getSub_Timetable() {
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        ConfigurationData configurationData = snapshot.data.configurationData;
        return ListView(
          children: <Widget>[
            SwitchListTile(
              value: configurationData.timetablesettings.centertext,
              onChanged: (newvalue) {
                ConfigurationData newdata = configurationData.copyWith();
                newdata.timetablesettings.centertext = newvalue;
                appSettingsBloc.setAppConfiguration(newdata);
              },
              title: Text(getString(context).centertext),
            ),
            SwitchListTile(
              value: configurationData.timetablesettings.useshortname,
              onChanged: (newvalue) {
                ConfigurationData newdata = configurationData.copyWith();
                newdata.timetablesettings.useshortname = newvalue;
                appSettingsBloc.setAppConfiguration(newdata);
              },
              title: Text(getString(context).useshortname),
            ),
            SwitchListTile(
              value: configurationData.timetablesettings.showgrid,
              onChanged: (newvalue) {
                ConfigurationData newdata = configurationData.copyWith();
                newdata.timetablesettings.showgrid = newvalue;
                appSettingsBloc.setAppConfiguration(newdata);
              },
              title: Text(getString(context).showgrid),
            ),
            ListTile(
              title: Text(getString(context).lessonheight),
              subtitle: Text('x' +
                  configurationData.timetablesettings.heightfactor.toString()),
              onTap: () {
                getTextFromInput(
                        context: context,
                        previousText: configurationData
                            .timetablesettings.heightfactor
                            .toString(),
                        title: getString(context).lessonheight,
                        keyboardType: TextInputType.numberWithOptions())
                    .then((newtext) {
                  if (newtext != null) {
                    try {
                      newtext = newtext.replaceAll(',', '.');
                      double value = double.parse(newtext);
                      assert(value is double && value > 0.0);
                      ConfigurationData newdata = configurationData.copyWith();
                      newdata.timetablesettings.heightfactor = value;
                      appSettingsBloc.setAppConfiguration(newdata);
                    } catch (e) {
                      print(e);
                    }
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget getSub_Timeline() {
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        final configurationData = snapshot.data.configurationData;
        return ListView(
          children: <Widget>[
            SwitchListTile(
              value: configurationData.timelineSettings.showLessons,
              onChanged: (newvalue) {
                final newdata = configurationData.copyWith();
                newdata.timelineSettings.showLessons = newvalue;
                appSettingsBloc.setAppConfiguration(newdata);
              },
              title: Text(bothlang(context,
                  de: 'Stunden anzeigen', en: 'Show Lessons')),
            ),
          ],
        );
      },
    );
  }

  Widget getSub_Navigation() {
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        ConfigurationData configurationData = snapshot.data.configurationData;
        Map<int, int> actionsdata = configurationData?.navigationactions ?? {};

        int getActionNumber(int index) {
          if (actionsdata.containsKey(index)) {
            return actionsdata[index] ?? index;
          } else {
            return index;
          }
        }

        bool isDefault(int index) {
          if (actionsdata[index] != null) {
            return false;
          } else {
            return true;
          }
        }

        return ListView(
          children: <Widget>[
            ListTile(
              title: Text('1. Tab'),
              leading: Icon(Icons.home),
              subtitle: Text(getString(context).home),
              enabled: false,
            ),
            ListTile(
              title: Text('2. Tab'),
              leading: Icon(allNavigationActions[getActionNumber(1)].iconData),
              subtitle: Text(allNavigationActions[getActionNumber(1)]
                  .name
                  .getText(context)),
              trailing: isDefault(1)
                  ? null
                  : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        actionsdata[1] = null;
                        appSettingsBloc.setAppConfiguration(configurationData
                            .copyWith(navigationactions: actionsdata));
                      }),
              onTap: () {
                int index = 1;
                selectItem<NavigationActionItem>(
                    context: context,
                    items: allNavigationActions.values.toList(),
                    builder: (context, item) {
                      return ListTile(
                        title: Text(item.name.getText(context)),
                        enabled: actionsdata[index] != item.id,
                        trailing: actionsdata[index] == item.id
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          actionsdata[index] = item.id;
                          appSettingsBloc.setAppConfiguration(configurationData
                              .copyWith(navigationactions: actionsdata));
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            ),
            ListTile(
              title: Text('3. Tab'),
              leading: Icon(allNavigationActions[getActionNumber(2)].iconData),
              subtitle: Text(allNavigationActions[getActionNumber(2)]
                  .name
                  .getText(context)),
              trailing: isDefault(2)
                  ? null
                  : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        actionsdata[2] = null;
                        appSettingsBloc.setAppConfiguration(configurationData
                            .copyWith(navigationactions: actionsdata));
                      }),
              onTap: () {
                int index = 2;
                selectItem<NavigationActionItem>(
                    context: context,
                    items: allNavigationActions.values.toList(),
                    builder: (context, item) {
                      return ListTile(
                        title: Text(item.name.getText(context)),
                        enabled: actionsdata[index] != item.id,
                        trailing: actionsdata[index] == item.id
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          actionsdata[index] = item.id;
                          appSettingsBloc.setAppConfiguration(configurationData
                              .copyWith(navigationactions: actionsdata));
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            ),
            ListTile(
              title: Text('4. Tab'),
              leading: Icon(allNavigationActions[getActionNumber(3)].iconData),
              subtitle: Text(allNavigationActions[getActionNumber(3)]
                  .name
                  .getText(context)),
              trailing: isDefault(3)
                  ? null
                  : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        actionsdata[3] = null;
                        appSettingsBloc.setAppConfiguration(configurationData
                            .copyWith(navigationactions: actionsdata));
                      }),
              onTap: () {
                int index = 3;
                selectItem<NavigationActionItem>(
                    context: context,
                    items: allNavigationActions.values.toList(),
                    builder: (context, item) {
                      return ListTile(
                        title: Text(item.name.getText(context)),
                        enabled: actionsdata[index] != item.id,
                        trailing: actionsdata[index] == item.id
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          actionsdata[index] = item.id;
                          appSettingsBloc.setAppConfiguration(configurationData
                              .copyWith(navigationactions: actionsdata));
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            ),
            ListTile(
              title: Text('5. Tab'),
              leading: Icon(Icons.folder),
              subtitle: Text(getString(context).library),
              enabled: false,
            ),
          ],
        );
      },
    );
  }

  Widget getSub_Calendar() {
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        ConfigurationData configurationData = snapshot.data.configurationData;
        CalendarSettings calsettings = configurationData.calendarSettings;
        return Column(
          children: <Widget>[
            ListTile(
              trailing: Checkbox(
                  value: calsettings.getEvent().enabled,
                  onChanged: (value) {
                    calsettings.indicators[CalIndicator.EVENT].enabled = value;
                    appSettingsBloc.setAppConfiguration(configurationData
                        .copyWith(calendarSettings: calsettings));
                  }),
              title: Text(getString(context).events),
              leading: Container(
                height: 24.0,
                width: 24.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: calsettings.getEvent().color),
              ),
              onTap: () {
                selectDesign(context, null).then((newdesign) {
                  calsettings.indicators[CalIndicator.EVENT].color =
                      newdesign.primary;
                  appSettingsBloc.setAppConfiguration(configurationData
                      .copyWith(calendarSettings: calsettings));
                });
              },
            ),
            ListTile(
              trailing: Checkbox(
                  value: calsettings.getTestAndExam().enabled,
                  onChanged: (value) {
                    calsettings.indicators[CalIndicator.TESTANDEXAM].enabled =
                        value;
                    appSettingsBloc.setAppConfiguration(configurationData
                        .copyWith(calendarSettings: calsettings));
                  }),
              title: Text(getString(context).testsandexams),
              leading: Container(
                height: 24.0,
                width: 24.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: calsettings.getTestAndExam().color),
              ),
              onTap: () {
                selectDesign(context, null).then((newdesign) {
                  calsettings.indicators[CalIndicator.TESTANDEXAM].color =
                      newdesign.primary;
                  appSettingsBloc.setAppConfiguration(configurationData
                      .copyWith(calendarSettings: calsettings));
                });
              },
            ),
            ListTile(
              trailing: Checkbox(
                  value: calsettings.getTask().enabled,
                  onChanged: (value) {
                    calsettings.indicators[CalIndicator.TASK].enabled = value;
                    appSettingsBloc.setAppConfiguration(configurationData
                        .copyWith(calendarSettings: calsettings));
                  }),
              title: Text(getString(context).tasks),
              leading: Container(
                height: 24.0,
                width: 24.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: calsettings.getTask().color),
              ),
              onTap: () {
                selectDesign(context, null).then((newdesign) {
                  calsettings.indicators[CalIndicator.TASK].color =
                      newdesign.primary;
                  appSettingsBloc.setAppConfiguration(configurationData
                      .copyWith(calendarSettings: calsettings));
                });
              },
            ),
            ListTile(
              trailing: Checkbox(
                  value: calsettings.getVacation().enabled,
                  onChanged: (value) {
                    calsettings.indicators[CalIndicator.VACATION].enabled =
                        value;
                    appSettingsBloc.setAppConfiguration(configurationData
                        .copyWith(calendarSettings: calsettings));
                  }),
              title: Text(getString(context).vacations),
              leading: Container(
                height: 24.0,
                width: 24.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: calsettings.getVacation().color),
              ),
              onTap: () {
                selectDesign(context, null).then((newdesign) {
                  calsettings.indicators[CalIndicator.VACATION].color =
                      newdesign.primary;
                  appSettingsBloc.setAppConfiguration(configurationData
                      .copyWith(calendarSettings: calsettings));
                });
              },
            ),
            ListTile(
              trailing: Checkbox(
                  value: calsettings.getWeekend().enabled,
                  onChanged: (value) {
                    calsettings.indicators[CalIndicator.WEEKEND].enabled =
                        value;
                    appSettingsBloc.setAppConfiguration(configurationData
                        .copyWith(calendarSettings: calsettings));
                  }),
              title: Text(getString(context).weekend),
              leading: Container(
                height: 24.0,
                width: 24.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: calsettings.getWeekend().color),
              ),
              onTap: () {
                selectDesign(context, null).then((newdesign) {
                  calsettings.indicators[CalIndicator.WEEKEND].color =
                      newdesign.primary;
                  appSettingsBloc.setAppConfiguration(configurationData
                      .copyWith(calendarSettings: calsettings));
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget getSub_Advanced() {
    return StreamBuilder<AppSettingsData>(
      stream: appSettingsBloc.appSettingsData,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        ConfigurationData configurationData = snapshot.data.configurationData;
        return ListView(
          children: <Widget>[
            SwitchListTile(
              value: configurationData.smalldevice,
              onChanged: (newvalue) {
                appSettingsBloc.setAppConfiguration(
                    configurationData.copyWith(smalldevice: newvalue));
              },
              title: Text(getString(context).smalldevice),
            ),
          ],
        );
      },
    );
  }
}
