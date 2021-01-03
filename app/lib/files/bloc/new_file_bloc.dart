import 'dart:io';
import 'package:bloc/bloc_base.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
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
    final cloudFile = cloudFileValue;
    cloudFile.name = name;
    _updateFile(cloudFileValue);
  }

  void changeUrl(String url) {
    final cloudFile = cloudFileValue;
    cloudFile.url = url;
    _updateFile(cloudFileValue);
  }

  void changeFileForm(FileForm fileForm) {
    final cloudFile = cloudFileValue;
    cloudFile.fileform = fileForm;
    _updateFile(cloudFileValue);
  }

  Future<void> selectFileFromFilePicker() async {
    final cloudFile = cloudFileValue;
    final pickedFile = await FileHelper().pickFile();
    if (pickedFile == null) return;
    File newFile;
    try {
      final compressedFile = ImageCompresser.compressImage(pickedFile);
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
        .child(cloudFile.savedin.id)
        .child(cloudFile.fileid)
        .putFile(newFile);
    // ignore: unawaited_futures
    _uploadEventsSubject.addStream(uploadTask.snapshotEvents);

    await uploadTask.then(
      (event) {
        cloudFile.type = event.metadata.contentType;
        event.ref.getDownloadURL().then(
          (downloadurl) {
            cloudFile.url = downloadurl.toString();
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
