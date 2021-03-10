//@dart = 2.11
import 'package:bloc/bloc_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Extras/Kilobyte.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/files/bloc/new_file_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';

Future<CloudFile> openNewFilePage(BuildContext context) {
  final navigationBloc = NavigationBloc.of(context);
  final database = PlannerDatabaseBloc.getDatabase(context);
  return navigationBloc.openSubPage<CloudFile>(
    builder: (context) => BlocProvider(
      bloc: NewFileBloc(database),
      child: _NewFilePage(),
    ),
  );
}

class _NewFilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewFileBloc>(context);
    return WillPopScope(
      child: Scaffold(
        appBar: MyAppHeader(title: getString(context).newfile),
        body: SingleChildScrollView(
          child: _Inner(),
        ),
        floatingActionButton: _Fab(),
      ),
      onWillPop: () async {
        if (bloc.hasChangedValues == false) return true;
        return showConfirmDialog(
            context: context,
            title: getString(context).discardchanges,
            action: getString(context).confirm,
            richtext: RichText(
                text: TextSpan(
              text: getString(context).currentchangesnotsaved,
            ))).then((value) {
          if (value == true) {
            return true;
          } else {
            return false;
          }
        });
      },
    );
  }
}

class _Inner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewFileBloc>(context);
    return StreamBuilder<CloudFile>(
      stream: bloc.cloudFile,
      initialData: bloc.cloudFileValue,
      builder: (context, snapshot) {
        final cloudFile = snapshot.data;
        return Column(children: [
          FormHeader(getString(context).general),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: StatefulTextField.standard(
              initialText: cloudFile.name ?? '',
              onChanged: bloc.changeName,
              labelText: getString(context).name,
            ),
          ),
          FormSpace(16.0),
          _FileCard(cloudFile: cloudFile),
        ]);
      },
    );
  }
}

class _FileCard extends StatelessWidget {
  final CloudFile cloudFile;

  const _FileCard({
    Key key,
    @required this.cloudFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewFileBloc>(context);
    return StreamBuilder<bool>(
        stream: bloc.isFileFormLocked,
        initialData: bloc.isFileFormLockedValue,
        builder: (context, snapshot) {
          final isFileFormLocked = snapshot.data;
          return FormSection(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                      child: Tab(
                        text: getString(context).upload,
                        icon: Icon(Icons.cloud_upload),
                      ),
                      onTap: isFileFormLocked
                          ? null
                          : () {
                              bloc.changeFileForm(FileForm.STANDARD);
                            },
                    )),
                    Expanded(
                        child: InkWell(
                      child: Tab(
                        text: 'Web-Link',
                        icon: Icon(Icons.link),
                      ),
                      onTap: isFileFormLocked
                          ? null
                          : () {
                              bloc.changeFileForm(FileForm.WEBLINK);
                            },
                    )),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 3.0,
                      width: double.infinity,
                    ),
                    Positioned(
                      left: cloudFile.fileform == FileForm.STANDARD
                          ? 0
                          : MediaQuery.of(context).size.width / 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 3.0,
                        color: getAccentColor(context),
                      ),
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    switch (cloudFile.fileform) {
                      case FileForm.STANDARD:
                        {
                          return StreamBuilder<int>(
                            stream: bloc.uploadState,
                            builder: (context, snapshot) {
                              final fileUploadState = snapshot.data;
                              return _StandardFile(
                                fileUploadState: fileUploadState,
                              );
                            },
                          );
                        }
                      case FileForm.WEBLINK:
                        {
                          return _WebLink(
                            cloudFile: cloudFile,
                          );
                        }
                      case FileForm.OLDTTYPE:
                        return Container();
                      default:
                        return Container();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}

class _StandardFile extends StatelessWidget {
  final int fileUploadState;

  const _StandardFile({Key key, @required this.fileUploadState})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewFileBloc>(context);
    switch (fileUploadState) {
      case 0:
        {
          return Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: RButton(
                    text: getString(context).selectfile,
                    onTap: () {
                      bloc.selectFileFromFilePicker();
                    },
                    iconData: Icons.folder_open,
                  ),
                ),
              ],
            ),
          );
        }
      case 1:
        {
          return StreamBuilder<TaskSnapshot>(
            stream: bloc.uploadEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError == true) {
                return Icon(Icons.error_outline);
              }
              final transferredbytes = snapshot.data.bytesTransferred;
              final totalbytes = snapshot.data.totalBytes;
              final isFinished = transferredbytes == totalbytes;
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      isFinished
                          ? getString(context).finished
                          : getString(context).uploading,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w500),
                    ),
                    FormSpace(8.0),
                    LinearProgressIndicator(
                      value: transferredbytes / totalbytes,
                      valueColor: isFinished
                          ? AlwaysStoppedAnimation<Color>(Colors.green)
                          : null,
                    ),
                    FormSpace(8.0),
                    Text(
                      (transferredbytes / totalbytes * 100).toStringAsFixed(1) +
                          '% ${getString(context).of_} ' +
                          KiloByteSize(bytes: totalbytes)
                              .inKilobytes
                              .toString() +
                          ' Kilobytes',
                    ),
                  ],
                ),
              );
            },
          );
        }
    }
    return Icon(Icons.error_outline);
  }
}

class _WebLink extends StatelessWidget {
  final CloudFile cloudFile;

  const _WebLink({Key key, @required this.cloudFile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewFileBloc>(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 8,
        right: 8,
      ),
      child: StatefulTextField.standard(
        initialText: cloudFile.url ?? '',
        onChanged: bloc.changeUrl,
        labelText: 'Link',
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewFileBloc>(context);
    final database = PlannerDatabaseBloc.getDatabase(context);
    return FloatingActionButton.extended(
      onPressed: () {
        final data = bloc.cloudFileValue;
        if (data.validate()) {
          database.dataManager.CreateNewFile(data);
          Navigator.pop(context, data);
        } else {
          final infoDialog = InfoDialog(
            title: getString(context).failed,
            message: getString(context).pleasecheckdata,
          );
          infoDialog.show(context);
        }
      },
      icon: Icon(Icons.done),
      label: Text(getString(context).done),
    );
  }
}
