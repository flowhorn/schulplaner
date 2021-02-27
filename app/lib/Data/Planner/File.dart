//@dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

enum FileForm { STANDARD, WEBLINK, OLDTTYPE }
enum SavedInType {
  PERSONAL,
  COURSE,
  CLASS,
}

class SavedIn {
  String id;
  SavedInType type;
  SavedIn({this.id, this.type});

  SavedIn.fromData(dynamic data) {
    id = data['id'];
    type = SavedInType.values[data['type']];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type?.index,
    };
  }
}

class CloudFile {
  String fileid, name;
  FileForm fileform;
  String url;
  SavedIn savedin;
  String type;

  CloudFile(
      {this.fileid,
      this.name,
      this.fileform,
      this.url,
      this.type,
      this.savedin});

  CloudFile.fromData(dynamic data) {
    fileid = data['fileid'];
    name = data['name'];
    fileform = FileForm.values[data['fileform']];
    url = data['url'];
    type = data['type'];
    savedin = SavedIn.fromData(data['savedin']?.cast<String, dynamic>());
  }

  Map<String, dynamic> toJson() {
    return {
      'fileid': fileid,
      'name': name,
      'fileform': fileform.index,
      'url': url,
      'type': type,
      'savedin': savedin?.toJson(),
    };
  }

  bool validate() {
    if (fileid == null) return false;
    if (name == null || name == '') return false;
    if (savedin == null) return false;
    if (url == null) return false;
    return true;
  }

  bool isImage() {
    if (type != null) {
      if (type.contains('image')) {
        return true;
      } else {
        return false;
      }
    } else {
      if (url == null) return false;
      final fileExtension =
          url.substring(url.lastIndexOf('.') + 1)?.toLowerCase() ?? '';
      if (fileExtension == 'jpg' || fileExtension == 'png') {
        return true;
      } else {
        return false;
      }
    }
  }
}

void OpenCloudFile(BuildContext context, CloudFile cloudfile) {
  switch (cloudfile.fileform) {
    case FileForm.STANDARD:
      {
        FirebaseStorage.instance
            .ref()
            .child('files')
            .child('personal')
            .child(cloudfile.savedin.id)
            .child(cloudfile.fileid)
            .getDownloadURL()
            .then((dynamic url) async {
          if (url != null) {
            final metaData = await FirebaseStorage.instance
                .ref()
                .child('files')
                .child('personal')
                .child(cloudfile.savedin.id)
                .child(cloudfile.fileid)
                .getMetadata();
            if (metaData.contentType.contains('image')) {
              showImage(context, url, cloudfile.name);
            } else {
              final finalUrl = url.toString();
              if (finalUrl.startsWith('https://')) {
                await launch(finalUrl);
              } else {
                await launch('https://' + finalUrl);
              }
            }
          }
        });
        break;
      }
    case FileForm.WEBLINK:
      {
        try {
          final fileExtension = cloudfile.url
                  .substring(cloudfile.url.lastIndexOf('.') + 1)
                  ?.toLowerCase() ??
              '';
          if (fileExtension == 'jpg' || fileExtension == 'png') {
            showImage(context, cloudfile.url, cloudfile.name);
          } else {
            launch('https:' + cloudfile.url);
          }
        } catch (e) {
          launch('https:' + cloudfile.url);
        }
        break;
      }
    case FileForm.OLDTTYPE:
      {
        FirebaseStorage.instance
            .ref()
            .child('attachments')
            .child(cloudfile.fileid)
            .getDownloadURL()
            .then((url) {
          if (url != null) launch('https:' + url);
        });
        break;
      }
  }
}

void showImage(BuildContext context, String url, String name) {
  pushWidget(
    context,
    Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: MyAppHeader(title: name ?? 'Image'),
        backgroundColor: Colors.black,
        body: Center(
          child: PhotoView(imageProvider: NetworkImage(url)),
        ),
        bottomNavigationBar: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ButtonBar(
            children: <Widget>[
              RButton(
                  text: getString(context).openinbrowser,
                  iconData: Icons.link,
                  onTap: () {
                    launch(url);
                  }),
              RButton(
                  text: getString(context).share,
                  iconData: Icons.share,
                  onTap: () {
                    launch(url);
                  }),
            ],
          ),
        ),
      ),
    ),
  );
}
