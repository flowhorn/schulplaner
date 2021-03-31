import 'package:bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerBloc extends BlocBase {
  final _isCollapsedSubject = BehaviorSubject<bool>.seeded(false);

  DrawerBloc() {
    _initializeCollapsedState();
  }

  Future<void> _initializeCollapsedState() async {
    final instance = await SharedPreferences.getInstance();
    final value = instance.getBool('drawer_is_collapsed') ?? false;
    _isCollapsedSubject.add(value);
  }

  Stream<bool> get isCollapsed => _isCollapsedSubject;

  bool get isCollapsedValue => _isCollapsedSubject.valueWrapper!.value;

  Future<void> setCollapsed(bool value) async {
    _isCollapsedSubject.add(value);
    final instance = await SharedPreferences.getInstance();
    await instance.setBool('drawer_is_collapsed', value);
  }

  @override
  void dispose() {
    _isCollapsedSubject.close();
  }
}
