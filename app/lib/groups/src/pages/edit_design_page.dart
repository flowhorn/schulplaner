import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/widgets/color_picker.dart';
import 'package:schulplaner8/groups/src/bloc/edit_design_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

Future<Design> createNewDesignFromEditDesignPage(
    {required BuildContext context}) async {
  return pushWidget<Design>(
    context,
    BlocProvider(
      bloc: EditDesignBloc(),
      child: EditDesignPage(),
    ),
  );
}

class EditDesignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditDesignBloc>(context);
    return WillPopScope(
        child: StreamBuilder<Design>(
            stream: bloc.design,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return CircularProgressIndicator();
              }
              final design = snapshot.data;
              return Theme(
                data: newAppThemeDesign(context, design),
                child: Scaffold(
                  appBar: MyAppHeader(
                      title: bloc.isEditMode
                          ? getString(context).editdesign
                          : getString(context).newdesign),
                  body: SingleChildScrollView(
                    child: _Inner(
                      design: design,
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
        });
  }
}

class _Inner extends StatelessWidget {
  final Design design;

  const _Inner({Key key, this.design}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditDesignBloc>(context);
    return Column(
      children: [
        FormSpace(12.0),
        StatefulTextField.standard(
          initialText: design.name,
          onChanged: bloc.changeName,
          labelText: getString(context).name,
          maxLength: 52,
          maxLengthEnforced: true,
          maxLines: 1,
        ),
        FormSpace(12.0),
        FormDivider(),
        ListTile(
          leading: Icon(
            Icons.color_lens,
            color: design.primary,
          ),
          title: Text(getString(context).primary),
          subtitle: Text(design.primary == null
              ? '-'
              : '#' + getHex(design.primary).toString()),
          onTap: () {
            selectColor(context, design.primary).then((newColor) {
              if (newColor != null) {
                bloc.changePrimary(newColor);
              }
            });
          },
        ),
        ListTile(
          leading: Icon(
            Icons.color_lens,
            color: design.accent,
          ),
          title: Text(getString(context).accent),
          subtitle: Text(design.accent == null
              ? '-'
              : '#' + getHex(design.accent).toString()),
          onTap: () {
            selectColor(context, design.accent).then((newColor) {
              if (newColor != null) {
                bloc.changeAccent(newColor);
                ;
              }
            });
          },
        ),
        FormDivider(),
        FormSpace(64.0),
      ],
    );
  }
}

class _Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditDesignBloc>(context);
    return FloatingActionButton.extended(
        onPressed: () {
          final currentValue = bloc.currentDesign;
          if (currentValue.validate()) {
            Navigator.pop(context, currentValue);
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
        label: Text(getString(context).done));
  }
}
