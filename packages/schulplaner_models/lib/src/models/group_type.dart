enum GroupType { course, schoolClass }

const _courseString = 'course';
const _schoolClassString = 'schoolClass';

extension GroupTypeConverter on GroupType {
  GroupType fromData(dynamic data) {
    if (data == _courseString) {
      return GroupType.course;
    }
    if (data == _schoolClassString) {
      return GroupType.schoolClass;
    }
    throw UnimplementedError();
  }

  String toData() {
    switch (this) {
      case GroupType.course:
        return _courseString;
      case GroupType.schoolClass:
        return _schoolClassString;
    }
  }
}
