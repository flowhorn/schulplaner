//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/Help.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

// ignore: must_be_immutable
class EmailView extends StatelessWidget {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: 'Email'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                      child: Card(
                        elevation: 0.0,
                        margin: EdgeInsets.all(6.0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: getDividerColor(context),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
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
                              SizedBox(height: 8.0),
                              FormTextField(
                                text: _email,
                                valueChanged: (newemail) {
                                  _email = newemail;
                                },
                                iconData: Icons.email,
                                labeltext: 'Email',
                                keyBoardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 16.0),
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
                              InkWell(
                                child: Center(
                                  child: TextButton.icon(
                                    icon: Icon(Icons.done),
                                    label: Text(getString(context).signin),
                                    onPressed: null,
                                    style: TextButton.styleFrom(
                                      disabledForegroundColor:
                                          getAccentColor(context),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  handleSignInEmail(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: EmailHelpLinks(),
          )
        ],
      ),
    );
  }

  void handleSignInEmail(BuildContext context) async {
    //ignore: unawaited_futures
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(getString(context).pleasewait),
            content: SizedBox(
              height: 100.0,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
        barrierDismissible: false);
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((authResult) {
      if (authResult.user != null) {
        Navigator.popUntil(context, (r) => r.isFirst);
      } else {
        Navigator.pop(context);
      }
    }, onError: (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(getString(context).error),
              content: ListTile(
                title: Text(getString(context).pleasecheckdata),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(getString(context).done))
              ],
              contentPadding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0));
        },
      );
    });
  }
}

// ignore: must_be_immutable
class RegisterEmailView extends StatelessWidget {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).register),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                      child: Card(
                        elevation: 0.0,
                        margin: EdgeInsets.all(6.0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: getDividerColor(context),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
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
                              SizedBox(height: 8.0),
                              FormTextField(
                                text: _email,
                                valueChanged: (newemail) {
                                  _email = newemail;
                                },
                                iconData: Icons.email,
                                labeltext: 'Email',
                                keyBoardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 16.0),
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
                              InkWell(
                                child: Center(
                                  child: TextButton.icon(
                                    icon: Icon(Icons.done),
                                    label: Text(getString(context).register),
                                    onPressed: null,
                                    style: TextButton.styleFrom(
                                      disabledForegroundColor:
                                          getAccentColor(context),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  handleRegisterEmail(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RegisterHelpLinks(),
          )
        ],
      ),
    );
  }

  void handleRegisterEmail(BuildContext context) async {
    //ignore: unawaited_futures
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(getString(context).pleasewait),
            content: SizedBox(
              height: 100.0,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
        barrierDismissible: false);
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((authResult) {
      if (authResult.user != null) {
        Navigator.popUntil(context, (r) => r.isFirst);
      } else {
        Navigator.pop(context);
      }
    }, onError: (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(getString(context).error),
              content: ListTile(
                title: Text(bothlang(context,
                    de: 'Bitte überprüfe deine Registrierungsdaten!',
                    en: 'Please check your data!')),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(getString(context).done))
              ],
              contentPadding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0));
        },
      );
    });
  }
}

class RegisterHelpLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: getDividerColor(context),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class EmailHelpLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: getDividerColor(context),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: LabeledIconButtonSmall(
                    onTap: () {
                      pushWidget(context, HelpView());
                    },
                    iconData: Icons.help,
                    name: getString(context).help,
                  )),
                  Expanded(
                      child: LabeledIconButtonSmall(
                    onTap: () {
                      pushReplaceWidget(context, RegisterEmailView());
                    },
                    iconData: Icons.person,
                    name: getString(context).register,
                  )),
                  Expanded(
                      child: LabeledIconButtonSmall(
                    onTap: () {
                      getTextFromInput(
                              context: context,
                              title: getString(context).forgotpassword,
                              previousText: '')
                          .then((newtext) {
                        if (newtext != null) {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: newtext);
                        }
                      });
                    },
                    iconData: Icons.vpn_key,
                    name: getString(context).forgotpassword,
                  )),
                ],
              ),
            ],
          )),
    );
  }
}
