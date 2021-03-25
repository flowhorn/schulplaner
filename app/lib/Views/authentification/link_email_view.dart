//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/Help.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

// ignore: must_be_immutable
class LinkEmailView extends StatelessWidget {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).linkemail),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                getString(context).data,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            FormTextField(
                              text: _email,
                              valueChanged: (newemail) {
                                _email = newemail;
                              },
                              iconData: Icons.email,
                              labeltext: 'Email',
                              keyBoardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            FormTextField(
                              text: _password,
                              valueChanged: (newpassword) {
                                _password = newpassword;
                              },
                              iconData: Icons.lock,
                              labeltext: getString(context).password,
                              keyBoardType: TextInputType.text,
                              obscureText: true,
                              maxLines: 1,
                            ),
                          ]..add(InkWell(
                              child: Center(
                                child: TextButton.icon(
                                  icon: Icon(Icons.done),
                                  label: Text(getString(context).linkit),
                                  onPressed: null,
                                  style: TextButton.styleFrom(
                                      onSurface: getAccentColor(context)),
                                ),
                              ),
                              onTap: () async {
                                //ignore: unawaited_futures
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text(getString(context).pleasewait),
                                        content: SizedBox(
                                          height: 100.0,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                      );
                                    },
                                    barrierDismissible: false);
                                await FirebaseAuth.instance.currentUser!
                                    .linkWithCredential(
                                        EmailAuthProvider.credential(
                                            email: _email, password: _password))
                                    .then((user) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }, onError: (error) {
                                  print(error);
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text(getString(context).error),
                                          content: ListTile(
                                            title: Text(getString(context)
                                                .pleasecheckdata),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                    getString(context).error))
                                          ],
                                          contentPadding: EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              top: 16.0));
                                    },
                                  );
                                });
                              },
                            )),
                        ),
                        elevation: 12.0,
                        margin: EdgeInsets.all(6.0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        clipBehavior: Clip.antiAlias,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: LabeledIconButtonSmall(
                      onTap: () {
                        pushWidget(
                          context,
                          HelpView(),
                        );
                      },
                      iconData: Icons.help,
                      name: getString(context).help,
                    )),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
              elevation: 12.0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0))),
            ),
          )
        ],
      ),
    );
  }
}
