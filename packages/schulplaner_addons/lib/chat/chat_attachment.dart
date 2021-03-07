//@dart=2.11
import 'package:schulplaner_addons/common/widgets/sheets.dart';
import 'package:schulplaner_addons/common/widgets/widgets.dart';
import 'package:schulplaner_addons/tools/image/file_helper.dart';
import 'package:schulplaner_addons/tools/image/image_helper.dart';
import 'package:schulplaner_addons/utils/file_utils.dart';
import 'package:flutter/material.dart';

enum ChatAttachmentType { image, document, text }

class ChatAttachment {
  final ChatAttachmentType type;
  final LocalFile file;
  final String text;

  ChatAttachment({this.type, this.file, this.text});
}

Future<ChatAttachment> selectChatAttachment(BuildContext context,
    {bool showPresets = false}) {
  return showSheet(
      title: null,
      context: context,
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150.0,
        ),
        children: <Widget>[
          SheetIconButton(
            title: 'Kamera',
            tooltip: 'Kamera öffnen',
            iconData: Icons.camera,
            onTap: () async {
              final file = await ImageHelper.pickImageCamera();
              if (file != null) {
                Navigator.pop(
                    context,
                    ChatAttachment(
                      type: ChatAttachmentType.image,
                      file: LocalFile(file),
                    ));
              }
            },
            radius: 50.0,
          ),
          SheetIconButton(
            title: 'Galerie',
            tooltip: 'Galerie öffnen',
            iconData: Icons.image,
            onTap: () async {
              final file = await ImageHelper.pickImageGallery();
              if (file != null) {
                Navigator.pop(
                    context,
                    ChatAttachment(
                      type: ChatAttachmentType.image,
                      file: LocalFile(file),
                    ));
              }
            },
            radius: 50.0,
          ),
          SheetIconButton(
            title: 'Dokument',
            tooltip: 'Dokument öffnen',
            iconData: Icons.insert_drive_file,
            onTap: () {
              FileHelper().pickFile().then((file) {
                if (file != null) {
                  Navigator.pop(
                      context,
                      ChatAttachment(
                        type: ChatAttachmentType.document,
                        file: LocalFile(file),
                      ));
                }
              });
            },
            radius: 50.0,
          ),
          if (showPresets)
            SheetIconButton(
              title: 'Vorlage',
              tooltip: 'Vorlagen öffnen',
              iconData: Icons.mail,
              onTap: () {
                Navigator.pop(
                    context,
                    ChatAttachment(
                      type: ChatAttachmentType.text,
                      text: 'Testvorlage Hallo [MAX]',
                    ));
              },
              radius: 50.0,
            ),
        ],
      ));
}
