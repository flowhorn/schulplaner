import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/Data/userdatabase.dart';

class UserDatabaseBloc extends BlocBase {
  final _currentUserIdSubject = BehaviorSubject<UserId?>();
  UserId? get currentUserId => _currentUserIdSubject.value;

  UserDatabase? userDatabase;

  void setAuthentification(UserId userId) {
    // Prevent unnesseccary reloads by checking currentUserId
    if (userId != currentUserId) {
      userDatabase?.onDestroy();
      userDatabase = UserDatabase(uid: userId.uid);
      _currentUserIdSubject.add(userId);
    }
  }

  void clearAuthentification() {
    _currentUserIdSubject.add(null);
    userDatabase?.onDestroy();
    userDatabase = null;
  }

  @override
  void dispose() {
    userDatabase?.onDestroy();
    _currentUserIdSubject.close();
  }
}
