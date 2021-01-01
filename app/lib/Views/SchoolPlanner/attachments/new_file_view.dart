import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner8/Helper/helper_views.dart';

class SelectFileView extends StatelessWidget {
  final PlannerDatabase database;

  SelectFileView({@required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).selectfile),
      body: StreamBuilder<List<CloudFile>>(
        builder: (context, snapshot) {
          List<CloudFile> files = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              CloudFile file = files[index];
              return ListTile(
                leading: ColoredCircleIcon(
                  icon: Icon(file.isImage() ? Icons.image : Icons.attach_file),
                ),
                title: Text(file.name),
                onTap: () {
                  Navigator.pop(context, file);
                },
              );
            },
            itemCount: files.length,
          );
        },
        stream: database.personalfiles.stream,
        initialData: database.personalfiles.data,
      ),
    );
  }
}
