import 'package:bloc/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:schulplaner8/Data/Planner/CourseTemplates.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/MyCloudFunctions.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/groups/src/gateway/course_gateway.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/groups/src/models/place.dart';
import 'package:schulplaner8/groups/src/models/place_link.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:schulplaner8/groups/src/models/teacher_link.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class EditCourseBloc extends BlocBase {
  final PlannerDatabase database;
  final CourseGateway courseGateway;

  final _showTeacherFormSubject = BehaviorSubject<bool>.seeded(false);
  final _showPlaceFormSubject = BehaviorSubject<bool>.seeded(false);
  final _showConnectFormSubject = BehaviorSubject<bool>.seeded(false);
  final _showSeveralFormSubject = BehaviorSubject<bool>.seeded(false);
  final _editModeSubject = BehaviorSubject<bool>();

  final _currentCourseSubject = BehaviorSubject<Course>();
  final _addToSchoolClassSubject = BehaviorSubject<String?>.seeded(null);
  final _addToPrivateCoursesSubject = BehaviorSubject<bool>();
  final _hasChangedValuesSubject = BehaviorSubject<bool>.seeded(false);

  EditCourseBloc.withEditState({
    required Course course,
    required this.database,
    required this.courseGateway,
  }) {
    _currentCourseSubject.add(course);
    _editModeSubject.add(true);
    _addToPrivateCoursesSubject.add(true);
  }

  EditCourseBloc.withCreateState({
    CourseTemplate? template,
    String? schoolClassId,
    required this.database,
    required this.courseGateway,
  }) {
    final courseId = database.dataManager.generateCourseId();
    final course = template != null
        ? Course.fromTemplate(
            courseid: courseId,
            template: template,
          )
        : Course.create(id: courseId).copyWith(
            design: getRandomDesign(),
          );
    _currentCourseSubject.add(course);
    if (schoolClassId != null) {
      _addToSchoolClassSubject.add(schoolClassId);
    }
    _addToPrivateCoursesSubject.add(schoolClassId == null);
    _editModeSubject.add(false);
  }

  Stream<bool> get showTeacherForm => _showTeacherFormSubject;
  Stream<bool> get showPlaceForm => _showPlaceFormSubject;
  Stream<bool> get showConnectForm => _showConnectFormSubject;
  Stream<bool> get showSeveralForm => _showSeveralFormSubject;

  Stream<Course> get currentCourse => _currentCourseSubject;
  Course get _currentCourseValue => _currentCourseSubject.valueWrapper!.value;
  bool get isEditMode => _editModeSubject.valueWrapper!.value;
  bool get hasChangedValues => _hasChangedValuesSubject.valueWrapper!.value;

  bool get addToPrivateCourses =>
      _addToPrivateCoursesSubject.valueWrapper!.value;
  bool get addToSchoolClass =>
      _addToSchoolClassSubject.valueWrapper!.value != null;
  Stream<String?> get schoolClassId => _addToSchoolClassSubject;

  void _updateCourse(Course newCourse) {
    _hasChangedValuesSubject.add(true);
    _currentCourseSubject.add(newCourse);
  }

  Function(bool) get changeShowTeacherForm => _showTeacherFormSubject.add;
  Function(bool) get changeShowPlaceForm => _showPlaceFormSubject.add;
  Function(bool) get changeShowConnectForm => _showConnectFormSubject.add;
  Function(bool) get changeShowSeveralForm => _showSeveralFormSubject.add;

  void changeDesign(Design design) {
    _updateCourse(_currentCourseValue.copyWith(design: design));
  }

  void changeName(String name) {
    _updateCourse(_currentCourseValue.copyWith(name: name));
  }

  void changeShortname(String shortname) {
    _updateCourse(_currentCourseValue.copyWith(shortname: shortname));
  }

  void changeDescription(String description) {
    _updateCourse(_currentCourseValue.copyWith(description: description));
  }

  void addPlace(Place place) {
    final placeLink = PlaceLink.fromPlace(place);
    final newCourse = _currentCourseValue.copyWith();
    newCourse.places[placeLink.placeid] = placeLink;
    _updateCourse(newCourse);
  }

  void removePlace(String placeId) {
    final newCourse = _currentCourseValue.copyWith();
    newCourse.places[placeId] = null;
    _updateCourse(newCourse);
  }

  void addTeacher(Teacher teacher) {
    final teacherLink = TeacherLink.fromTeacher(teacher);
    final newCourse = _currentCourseValue.copyWith();
    newCourse.teachers[teacherLink.teacherid] = teacherLink;
    _updateCourse(newCourse);
  }

  void removeTeacher(String teacherId) {
    final newCourse = _currentCourseValue.copyWith();
    newCourse.teachers[teacherId] = null;
    _updateCourse(newCourse);
  }

  void addSchoolClass(String schoolClassId) {
    _addToSchoolClassSubject.add(schoolClassId);
    _addToPrivateCoursesSubject.add(false);
  }

  void removeSchoolClass() {
    _addToSchoolClassSubject.add(null);
    _addToPrivateCoursesSubject.add(true);
  }

  Future<bool> submit({
    required BuildContext context,
  }) async {
    final course = _currentCourseSubject.valueWrapper!.value;
    final schoolClassId = _addToSchoolClassSubject.valueWrapper!.value;
    if (course.validate() == true) {
      if (isEditMode) {
        await requestSimplePermission(
                context: context,
                database: database,
                category: PermissionAccessType.edit,
                id: course.id)
            .then((result) {
          if (result) {
            database.dataManager.ModifyCourse(course);
            Navigator.pop(context);
          }
        });
      } else {
        if (schoolClassId == null) {
          courseGateway.CreateCourseAsCreator(course);

          Navigator.pop(context);
        } else {
          await requestSimplePermission(
            context: context,
            database: database,
            category: PermissionAccessType.edit,
            id: schoolClassId,
            type: 1,
          ).then(
            (result) async {
              if (result) {
                courseGateway.CreateCourseAsCreator(course);
                await addCourseToClass(
                  courseid: course.id,
                  classid: schoolClassId,
                );
                Navigator.pop(context);
              }
            },
          );
        }
      }
    } else {
      final infoDialog = InfoDialog(
        title: getString(context).failed,
        message: getString(context).pleasecheckdata,
      );
      // ignore: unawaited_futures
      infoDialog.show(context);
    }
    return false;
  }

  @override
  void dispose() {
    _showTeacherFormSubject.close();
    _showPlaceFormSubject.close();
    _showConnectFormSubject.close();
    _showSeveralFormSubject.close();
    _currentCourseSubject.close();
    _editModeSubject.close();
    _addToSchoolClassSubject.close();
    _hasChangedValuesSubject.close();
    _addToPrivateCoursesSubject.close();
  }
}
