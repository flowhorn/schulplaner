//@dart=2.11
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/widgets/color_picker.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/settings/src/blocs/edit_appearance_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

Future<void> openEditAppearancePage(BuildContext context) async {
  final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
  await pushWidget(
    context,
    BlocProvider(
      bloc: EditApperanceBloc(appSettingsBloc),
      child: _EditApperancePage(),
    ),
  );
}

class _EditApperancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditApperanceBloc>(context);
    return StreamBuilder<AppSettingsData>(
      initialData: bloc.currentValue,
      stream: bloc.appSettingsData,
      builder: (context, snapshot) {
        final appSettingsData = snapshot.data;
        return Theme(
          data: appSettingsData.getThemeData(),
          child: Scaffold(
            appBar: MyAppHeader(title: getString(context).appearance),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FormHeader(getString(context).colours),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: appSettingsData.primary,
                    ),
                    title: Text(getString(context).primary),
                    subtitle:
                        Text('#' + getHex(appSettingsData.primary).toString()),
                    onTap: () {
                      selectColor(context, appSettingsData.primary)
                          .then((newColor) {
                        if (newColor != null) {
                          bloc.setPrimary(newColor);
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: appSettingsData.accent,
                    ),
                    title: Text(getString(context).accent),
                    subtitle:
                        Text('#' + getHex(appSettingsData.accent).toString()),
                    onTap: () {
                      selectColor(context, appSettingsData.accent)
                          .then((newColor) {
                        if (newColor != null) {
                          bloc.setAccent(newColor);
                        }
                      });
                    },
                  ),
                  FormDivider(),
                  FormHeader(getString(context).configure),
                  SwitchListTile(
                    value: appSettingsData.darkmode ?? false,
                    onChanged: (newvalue) {
                      bloc.setDarkMode(newvalue);
                    },
                    title: Text(getString(context).darkmode),
                  ),
                  SwitchListTile(
                    value: appSettingsData.autodark ?? false,
                    onChanged: appSettingsData.darkmode
                        ? null
                        : (newvalue) {
                            bloc.setAutoDark(newvalue);
                          },
                    title: Text(getString(context).automaticdarkmode),
                  ),
                  SwitchListTile(
                      value: appSettingsData.coloredAppBar ?? true,
                      onChanged: (newvalue) {
                        bloc.setColoredAppBar(newvalue);
                      },
                      title: Text(getString(context).coloredappbar)),
                  FormDivider(),
                ],
              ),
            ),
            floatingActionButton: _Fab(),
          ),
        );
      },
    );
  }
}

class _Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditApperanceBloc>(context);
    return FloatingActionButton.extended(
      onPressed: () {
        if (bloc.currentValue.validate()) {
          bloc.submit();
          Navigator.pop(context);
        }
      },
      icon: Icon(Icons.done),
      label: Text(getString(context).accept),
    );
  }
}
