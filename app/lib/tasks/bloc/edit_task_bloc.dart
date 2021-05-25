import 'package:bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';

class EditTaskBloc extends BlocBase {
  final PlannerDatabase database;

  final _showTeacherFormSubject = BehaviorSubject<bool>.seeded(false);
  final _editModeSubject = BehaviorSubject<bool>();

  final _currentTaskSubject = BehaviorSubject<SchoolTask>();
  final _hasChangedValuesSubject = BehaviorSubject<bool>.seeded(false);

  EditTaskBloc(this.database);

  Stream<bool> get showTeacherForm => _showTeacherFormSubject;

  Stream<SchoolTask> get currenSchoolTask => _currentTaskSubject;
  SchoolTask get _currenSchoolTaskValue => _currentTaskSubject.value;
  bool get isEditMode => _editModeSubject.value;
  bool get hasChangedValues => _hasChangedValuesSubject.value;

  void _updateTask(SchoolTask newTask) {
    _hasChangedValuesSubject.add(true);
    _currentTaskSubject.add(newTask);
  }

  Function(bool) get changeShowTeacherForm => _showTeacherFormSubject.add;

  void changeTitle(String title) {
    final schoolTask = _currenSchoolTaskValue.copy();
    schoolTask.title = title;
    _updateTask(schoolTask);
  }

  void changeDetail(String detail) {
    final schoolTask = _currenSchoolTaskValue.copy();
    schoolTask.detail = detail;
    _updateTask(schoolTask);
  }

  @override
  void dispose() {
    _showTeacherFormSubject.close();
    _currentTaskSubject.close();
    _editModeSubject.close();
    _hasChangedValuesSubject.close();
  }
}
