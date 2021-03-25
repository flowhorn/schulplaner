import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Views/SchoolPlanner/overview/action_view.dart';
import 'package:schulplaner8/files/pages/new_file_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';

import 'new_file_view.dart';

class EditAttachementsView extends StatelessWidget {
  final PlannerDatabase database;
  final Map<String, CloudFile?>? attachments;
  final ValueSetter<CloudFile> onAdded, onRemoved;
  EditAttachementsView(
      {required this.database,
      required this.attachments,
      required this.onAdded,
      required this.onRemoved});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormHeader(getString(context).attachments),
        if (attachments != null)
          for (final it
              in attachments!.values.where((element) => element != null))
            ListTile(
              leading: ColoredCircleIcon(
                icon: Icon(Icons.attach_file),
              ),
              title: Text(it!.name ?? '???'),
              subtitle: it.url == null
                  ? null
                  : Text(
                      it.url!,
                      style: TextStyle(color: Colors.blue),
                    ),
              trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    onRemoved(it);
                  }),
            ),
        FormButton(
          getString(context).newattachment,
          () {
            showFileSheet(context);
          },
          iconData: Icons.add_circle,
        ),
      ],
    );
  }

  Future<void> showFileSheet(BuildContext context) {
    return showDetailSheetBuilder(
        context: context,
        body: (context) {
          return Column(
            children: <Widget>[
              getSheetText(context, getString(context).newattachment),
              SizedBox(
                height: 140.0,
                child: Row(
                  children: <Widget>[
                    ActionView(
                        iconData: Icons.add_circle_outline,
                        text: getString(context).newfile,
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.pop(context);
                          openNewFilePage(context).then((newfile) {
                            if (newfile != null && newfile is CloudFile) {
                              onAdded(newfile);
                            }
                          });
                        }),
                    ActionView(
                        iconData: Icons.select_all,
                        text: getString(context).select,
                        color: Colors.redAccent,
                        onTap: () {
                          Navigator.pop(context);
                          pushWidget(
                                  context, SelectFileView(database: database))
                              .then((newfile) {
                            if (newfile != null && newfile is CloudFile) {
                              onAdded(newfile);
                            }
                          });
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
            ],
          );
        });
  }
}
