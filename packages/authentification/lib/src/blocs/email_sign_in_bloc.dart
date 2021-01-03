import 'package:bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';

class EmailSignInBloc extends BlocBase {
  final _emailSubject = BehaviorSubject<String>.seeded('');
  final _passwordSubject = BehaviorSubject<String>.seeded('');

  Stream<String> get email => _emailSubject;
  Stream<String> get password => _passwordSubject;

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
  }
}
