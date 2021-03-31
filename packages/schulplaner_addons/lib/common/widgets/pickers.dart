import 'package:flutter/material.dart';
import 'package:schulplaner_addons/common/widgets/sheets.dart';
import 'package:schulplaner_addons/common/widgets/widgets.dart';
import 'package:schulplaner_addons/tools/image/image_helper.dart';
import 'package:schulplaner_addons/utils/date_utils.dart' as date_utils;
import 'package:schulplaner_addons/utils/file_utils.dart';

Future<String?> selectDate(BuildContext context, {String? initialDate}) {
  return showDatePicker(
    context: context,
    firstDate: DateTime.parse('1950-01-01'),
    lastDate: DateTime.parse('2029-12-31'),
    initialDate: initialDate == null
        ? DateTime.now()
        : date_utils.DateUtils.parseDateTime(initialDate),
  ).then((result) {
    if (result == null) {
      return null;
    } else {
      return date_utils.DateUtils.parseDateString(result);
    }
  });
}

Future<TimeOfDay?> selectTime(BuildContext context, {TimeOfDay? initialTime}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
  ).then((result) {
    if (result == null) {
      return null;
    } else {
      return result;
    }
  });
}

Future<LocalFile?> selectImage(BuildContext context,
    {bool resize = false}) async {
  LocalFile? localFile = await showSheet<LocalFile>(
      context: context,
      title: 'Bild auswählen',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SheetIconButton(
            title: 'Kamera',
            tooltip: 'Kamera öffnen',
            iconData: Icons.camera,
            onTap: () {
              ImageHelper.pickImageCamera().then((file) {
                if (file != null) {
                  Navigator.pop(context, LocalFile(file));
                }
              });
            },
          ),
          SheetIconButton(
            title: 'Galerie',
            tooltip: 'Galerie öffnen',
            iconData: Icons.image,
            onTap: () {
              ImageHelper.pickImageGallery().then((file) {
                if (file != null) {
                  Navigator.pop(context, LocalFile(file));
                }
              });
            },
          )
        ],
      ));
  if (localFile == null) {
    return null;
  } else {
    if (resize) {
      final croppedFile = await ImageHelper.cropImage(localFile.file);
      return croppedFile != null ? LocalFile(croppedFile) : null;
    } else {
      return localFile;
    }
  }
}
