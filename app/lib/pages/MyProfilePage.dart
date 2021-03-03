//@dart=2.11
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/userdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/profile/user_image_view.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/AppState.dart';
import 'package:schulplaner8/models/additionaltypes.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/models/user.dart';

// ignore: must_be_immutable
class EditProfileView extends StatelessWidget {
  final UserDatabase userDatabase;

  bool changedValues = false;
  UserProfile data;
  final ValueNotifier<UserProfile> notifier = ValueNotifier(null);

  EditProfileView({@required this.userDatabase}) {
    data = userDatabase.userprofile.data ??
        UserProfile.create(uid: userDatabase.uid);
    notifier.value = data;
  }

  void update(UserProfile newdata) {
    data = newdata;
    notifier.value = newdata;
    changedValues = true;
  }

  void updateNotNotify(UserProfile newdata) {
    data = newdata;
    changedValues = true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile>(
      valueListenable: notifier,
      builder: (context, _, _a) {
        return Scaffold(
          appBar: MyAppHeader(
            title: getString(context).editprofile,
          ),
          body: getDefaultList([
            FormHeader2(getString(context).info),
            FormSpace(6.0),
            FormTextField(
              text: data.name,
              valueChanged: (newText) =>
                  updateNotNotify(data.copyWith(name: newText)),
              labeltext: getString(context).name,
              maxLength: 36,
            ),
            FormSpace(4.0),
            FormDivider(),
            FormSection(
              title: bothlang(context, de: 'Anzeigemodus', en: 'Displaymode'),
              child: Column(
                children: <Widget>[
                  RadioListTile<ProfileDisplayMode>(
                    title: Text(bothlang(context,
                        de: 'Profilbild', en: 'Profilepicture')),
                    groupValue: data.displayMode,
                    value: ProfileDisplayMode.pic,
                    onChanged: (newvalue) {
                      print(data);
                      update(
                          data.copyWith(displayMode: ProfileDisplayMode.pic));
                    },
                  ),
                ],
              ),
            ),
            FormSpace(16.0),
            Center(
              child: UserImageView(userProfile: data, size: 148.0),
            ),
            FormSpace(8.0),
            Builder(
              builder: (context) {
                switch (data.displayMode) {
                  case ProfileDisplayMode.pic:
                    {
                      return ButtonBar(
                        children: <Widget>[
                          RButton(
                              text: bothlang(context,
                                  de: 'Neues Bild', en: 'New Picture'),
                              onTap: () {
                                selectItem<SimpleItem>(
                                    context: context,
                                    items: [
                                      SimpleItem(
                                          id: '0',
                                          name: bothlang(context,
                                              de: 'Kamera', en: 'Camera'),
                                          iconData: Icons.camera),
                                      SimpleItem(
                                          id: '1',
                                          name: bothlang(context,
                                              de: 'Galerie', en: 'Gallery'),
                                          iconData: Icons.image),
                                    ],
                                    builder: (context, item) {
                                      return ListTile(
                                          title: Text(item.name),
                                          leading: Icon(item.iconData),
                                          onTap: () async {
                                            await _selectImageMethod(
                                                context, item);
                                          });
                                    });
                              }),
                          RButton(
                              text: bothlang(context,
                                  de: 'Bild entfernen', en: 'Remove Picture'),
                              onTap: () {
                                update(data.copyWithNoPic());
                              })
                        ],
                        alignment: MainAxisAlignment.center,
                      );
                    }
                  default:
                    {
                      return Container();
                    }
                }
              },
            ),
            FormSpace(64.0),
          ]),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (data.validate()) {
                  userDatabase.userprofile.reference.set(data.toJson());
                  Navigator.pop(context);
                } else {}
              },
              icon: Icon(Icons.done),
              label: Text(getString(context).done)),
        );
      },
    );
  }

  Future<void> _selectImageMethod(BuildContext context, SimpleItem item) async {
    Navigator.pop(context);
    if (item.id == '0') {
      final file =
          await ImageHelper.pickImageCamera(maxWidth: 1024, maxHeight: 1024);
      if (file != null) {
        final compressedFile = await ImageCompresser.compressImage(file);
        final croppedFile = await ImageHelper.cropImage(compressedFile);
        if (croppedFile != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(data.uid)
              .child('profilepicture')
              .child('pic.jpg');
          final upload = ref.putFile(croppedFile);
          await upload.then((result) async {
            final picurl = await ref.getDownloadURL();
            update(data.copyWith(pic: picurl));
          });
        } else {
          print('croppedFile is null..');
        }
      }
    } else if (item.id == '1') {
      final file = await ImageHelper.pickImageGallery();

      if (file != null) {
        final compressedFile = await ImageCompresser.compressImage(file);
        final croppedFile = await ImageHelper.cropImage(compressedFile);
        if (croppedFile != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(data.uid)
              .child('profilepicture')
              .child('pic.jpg');
          final upload = ref.putFile(croppedFile);
          await upload.then((result) async {
            final picurl = await ref.getDownloadURL();
            update(data.copyWith(pic: picurl));
          });
        } else {
          print('croppedFile is null..');
        }
      }
    }
  }
}

class MemberImageView extends StatelessWidget {
  final bool thumbnailMode;
  final MemberData memberData;

  const MemberImageView(
      {@required this.thumbnailMode, @required this.memberData});

  @override
  Widget build(BuildContext context) {
    switch (memberData?.displayMode) {
      case ProfileDisplayMode.pic:
        {
          String url = memberData.pic;
          if (thumbnailMode && memberData.picThumb != null) {
            url = memberData.picThumb;
          }
          return ClipOval(
            clipBehavior: Clip.antiAlias,
            child: (url != null)
                ? Image.network(
                    url,
                    //width: 86.0,
                    //height: 86.0,
                  )
                : CircleAvatar(
                    child: Icon(
                      Icons.person,
                      //size: 32.0,
                    ),
                    //radius: 43.0,
                  ),
          );
        }
      case ProfileDisplayMode.none:
        {
          return CircleAvatar(
            child: Icon(
              Icons.person,
            ),
          );
        }
    }
    throw 'No DisplayMode selected';
  }
}
