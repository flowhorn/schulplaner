import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/user_database_bloc.dart';
import 'package:schulplaner8/models/user.dart';
import 'package:schulplaner8/pages/MyProfilePage.dart';
import 'package:schulplaner8/profile/user_image_view.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class MyProfile extends StatelessWidget {
  MyProfile();
  @override
  Widget build(BuildContext context) {
    final userDatabaseBloc = BlocProvider.of<UserDatabaseBloc>(context);
    return clearAppTheme(
        context: context,
        child: DataDocumentWidget<UserProfile>(
          package: userDatabaseBloc.userDatabase?.userprofile,
          allowNull: true,
          builder: (context, data) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text(getString(context).profile),
                centerTitle: true,
                elevation: 2.0,
                actions: <Widget>[
                  FlatButton(
                    child: Text(getString(context).edit.toUpperCase()),
                    onPressed: () {
                      pushWidget(
                          context,
                          EditProfileView(
                            userDatabase: userDatabaseBloc.userDatabase,
                          ));
                    },
                    textTheme: ButtonTextTheme.accent,
                  ),
                ],
                bottom: PreferredSize(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 12.0,
                      ),
                      SizedBox(
                        width: 148.0,
                        height: 148.0,
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topCenter,
                                child: UserImageView(
                                  userProfile: data,
                                  size: 148.0,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        data?.name ?? getString(context).anonymoususer,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 28.0,
                      ),
                    ],
                  ),
                  preferredSize: Size(double.infinity, 280.0),
                ),
              ),
            );
          },
        ));
  }
}
