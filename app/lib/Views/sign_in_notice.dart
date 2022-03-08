import 'package:flutter/material.dart';
import 'package:schulplaner8/configuration/configuration_bloc.dart';

import '../Helper/helper_data.dart';

class SignInNotice extends StatelessWidget {
  final bool isHideable;
  const SignInNotice({Key? key, this.isHideable = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configurationBloc = ConfigurationBloc.get(context);
    return StreamBuilder<bool>(
      stream: configurationBloc.showSignInNoticeStream,
      initialData: configurationBloc.showSignInNoticeValue,
      builder: (context, showSignInNoticeSnapshot) {
        final showSignInNotice = showSignInNoticeSnapshot.data!;
        if (showSignInNotice == false) return Container();
        return StreamBuilder<bool>(
            initialData: configurationBloc.hideSignInNoticeSubject.value,
            stream: configurationBloc.hideSignInNoticeSubject,
            builder: (context, hideSignInNoticeSnapshot) {
              final hideSignInNotice = hideSignInNoticeSnapshot.data!;
              if (hideSignInNotice == true) return Container();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.orange.withOpacity(0.3),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 64,
                        ),
                        Text(
                          bothlang(
                            context,
                            de: 'Schulplaner wird ab dem 1.5.2022  nur noch für bestehende Nutzer verfügbar sein. '
                                'Neue Nutzer können die App ab dann leider nicht mehr benutzen!',
                            en: 'Schoolplanner will be  available only for existing users from May 2022 on.'
                                'Unfortunately new users will not be able to use the app anymore!',
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        if (isHideable)
                          TextButton(
                            onPressed: () {
                              configurationBloc.hideSignInNotice();
                            },
                            child: Text('Hinweis nicht mehr anzeigen'),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
