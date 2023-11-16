import 'dart:io';
import 'package:bloc/bloc_base.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';

class NewFileBloc extends BlocBase {
  final PlannerDatabase database;

  final _cloudFileSubject = BehaviorSubject<CloudFile>();
  final _hasChangedValuesSubject = BehaviorSubject<bool>.seeded(false);

  final _isFileFormLockedSubject = BehaviorSubject<bool>.seeded(false);
  final _uploadEventsSubject = BehaviorSubject<TaskSnapshot>();
  final _uploadStateSubject = BehaviorSubject<int>.seeded(0);
  NewFileBloc(this.database) {
    _cloudFileSubject.add(
      CloudFile(
        fileid: database.dataManager.generateFileId(),
        savedin: SavedIn(
          id: database.uid,
          type: SavedInType.PERSONAL,
        ),
        name: '',
        fileform: FileForm.STANDARD,
      ),
    );
  }

  Stream<CloudFile> get cloudFile => _cloudFileSubject;
  CloudFile get cloudFileValue => _cloudFileSubject.value;
  bool get hasChangedValues => _hasChangedValuesSubject.value;

  Stream<bool> get isFileFormLocked => _isFileFormLockedSubject;
  Stream<TaskSnapshot> get uploadEvents => _uploadEventsSubject;
  Stream<int> get uploadState => _uploadStateSubject;
  bool get isFileFormLockedValue => _isFileFormLockedSubject.value;

  void _updateFile(CloudFile newFile) {
    _hasChangedValuesSubject.add(true);
    _cloudFileSubject.add(newFile);
  }

  void changeName(String name) {
    _updateFile(cloudFileValue.copyWith(name: name));
  }

  void changeUrl(String url) {
    _updateFile(cloudFileValue.copyWith(url: url));
  }

  void changeFileForm(FileForm fileForm) {
    _updateFile(cloudFileValue.copyWith(fileform: fileForm));
  }

  Future<void> selectFileFromFilePicker() async {
    var cloudFile = cloudFileValue;
    final pickedFile = await FileHelper().pickFile();
    if (pickedFile == null) return;
    XFile newFile;
    try {
      final compressedFile = await ImageCompresser.compressImage(pickedFile);
      newFile = compressedFile ?? pickedFile;
    } catch (e) {
      newFile = pickedFile;
    }
    _isFileFormLockedSubject.add(true);
    _uploadStateSubject.add(1);
    final uploadTask = FirebaseStorage.instance
        .ref()
        .child('files')
        .child('personal')
        .child(cloudFile.savedin!.id!)
        .child(cloudFile.fileid!)
        .putData(await newFile.readAsBytes());
    // ignore: unawaited_futures
    _uploadEventsSubject.addStream(uploadTask.snapshotEvents);

    await uploadTask.then(
      (event) {
        cloudFile = cloudFile.copyWith(type: event.metadata!.contentType);
        _updateFile(cloudFile);
        event.ref.getDownloadURL().then(
          (downloadurl) {
            cloudFile = cloudFile.copyWith(url: downloadurl);
            _updateFile(cloudFile);
          },
        );
      },
    );

    await database.dataManager.filesPersonalRef
        .doc(cloudFile.fileid)
        .set(cloudFile.toJson());
  }

  @override
  void dispose() {
    _cloudFileSubject.close();
    _isFileFormLockedSubject.close();
    _hasChangedValuesSubject.close();
    _uploadStateSubject.close();
  }
}
