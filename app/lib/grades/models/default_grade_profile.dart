import 'grade_profile.dart';
import 'grade_type.dart';
import 'grade_type_item.dart';

final GradeProfile defaulgradeprofile = GradeProfile.Create('default').copyWith(
  name: "Default",
  types: {
    "0": GradeTypeItem.Create("0").copyWith(name: "Exams", gradetypes: {
      GradeType.EXAM: true,
      GradeType.ORALEXAM: true,
    }),
    "1": GradeTypeItem.Create("1").copyWith(name: "Rest", gradetypes: {
      GradeType.GENERAL_PARTICIPATION: true,
      GradeType.HOMEWORK: true,
      GradeType.TEST: true,
      GradeType.OTHER: true,
    }),
  },
);
