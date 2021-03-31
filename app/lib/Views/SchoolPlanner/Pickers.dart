import 'package:flutter/material.dart';
import 'package:schulplaner8/groups/src/pages/edit_design_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Courses.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Places.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Teachers.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/groups/src/models/place.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:schulplaner8/models/school_class.dart';

Future<Design?> selectDesign(BuildContext context, String? currentkey) async {
  Design? selected;
  return await selectItem<Design>(
      context: context,
      items: designPresets(),
      builder: (context, design) => ListTile(
            leading: Icon(
              Icons.color_lens,
              color: design.primary,
            ),
            title: Text(design.name),
            onTap: () {
              selected = design;
              Navigator.pop(context);
            },
          ),
      actions: (context) => [
            RButton(
                onTap: () async {
                  await createNewDesignFromEditDesignPage(context: context)
                      .then((newDesign) {
                    if (newDesign != null && newDesign is Design) {
                      selected = newDesign;
                      Navigator.pop(context);
                    }
                  });
                },
                iconData: Icons.add,
                text: getString(context).newdesign.toUpperCase()),
            /*
            RButton(
                onTap: () {},
                iconData: Icons.search,
                text: "Weitere".toUpperCase()),
             */
          ]).then((value) {
    return Future.value(selected);
  });
}

Future<Teacher?> selectTeacher(
  BuildContext context,
  PlannerDatabase database,
  Map<String, dynamic>? current,
) async {
  Teacher? selected;
  return await selectItemAsync<Teacher>(
      context: context,
      itemstream: database.teachers.stream,
      builder: (context, teacher) {
        bool isSelected = (current ?? {})[teacher.teacherid] != null;
        return ListTile(
          title: Text(teacher.name),
          trailing: selectedView(isSelected),
          onTap: isSelected
              ? null
              : () {
                  selected = teacher;
                  Navigator.pop(context);
                },
          enabled: isSelected == false,
        );
      },
      actions: (context) => [
            RButton(
                onTap: () {
                  pushWidget(
                      context,
                      NewTeacherView(
                        database: database,
                      ));
                },
                iconData: Icons.add,
                text: getString(context).newteacher.toUpperCase()),
          ]).then((_) {
    return Future.value(selected);
  });
}

Future<Place?> selectPlace(
  BuildContext context,
  PlannerDatabase database,
  Map<String, dynamic>? current,
) async {
  Place? selected;
  return await selectItemAsync<Place>(
      context: context,
      itemstream: database.places.stream,
      builder: (context, item) {
        bool isSelected = ((current ?? {})[item.placeid] != null);
        return ListTile(
          title: Text(item.name),
          trailing: selectedView(isSelected),
          onTap: isSelected
              ? null
              : () {
                  selected = item;
                  Navigator.pop(context);
                },
        );
      },
      actions: (context) => [
            RButton(
                onTap: () {
                  pushWidget(
                      context,
                      NewPlaceView(
                        database: database,
                      ));
                },
                iconData: Icons.add,
                text: getString(context).newplace.toUpperCase()),
          ]).then((_) {
    return Future.value(selected);
  });
}

Future<Course?> selectCourse(
  BuildContext context,
  PlannerDatabase database,
  String? currentkey,
) async {
  Course? selected;
  return await selectItemAsync<Course>(
      context: context,
      itemstream: database.courseinfo.stream.map((data) {
        return data.values.toList()
          ..sort((c1, c2) {
            return c1.getName().compareTo(c2.getName());
          });
      }),
      builder: (context, item) => ListTile(
            leading: ColoredCircleText(
              text: toShortNameLength(context, item.getShortname_full()),
              color: item.getDesign()?.primary,
              radius: 18.0,
              textsize: 14.0,
            ),
            title: Text(item.getName()),
            onTap: () {
              selected = item;
              Navigator.pop(context);
            },
          ),
      actions: (context) => [
            RButton(
                onTap: () {
                  showNewCourseSheet(context, database);
                },
                iconData: Icons.add,
                text: getString(context).newcourse.toUpperCase()),
          ]).then((value) {
    return Future.value(selected);
  });
}

class SavedInValueItem {
  final String id;
  final String name;
  final SavedInType type;
  final Color? color;

  const SavedInValueItem({
    required this.id,
    required this.name,
    required this.type,
    this.color,
  });
}

Future<SavedInValueItem?> selectSavedin(
    BuildContext context, PlannerDatabase database, String currentkey) async {
  dynamic selected;
  return await selectItemAsync<SavedInValueItem>(
      context: context,
      itemstream: getMergedStream(database.courseinfo.stream.map((data) {
        return data.values.toList()
          ..sort((c1, c2) {
            return c1.getName().compareTo(c2.getName());
          });
      }), database.schoolClassInfos.stream.map((data) {
        return data.values.toList()
          ..sort((c1, c2) {
            return c1.getName().compareTo(c2.getName());
          });
      })).map<List<SavedInValueItem>>((twoobjects) {
        List<Course> courses = twoobjects.item ?? [];
        List<SchoolClass> classes = twoobjects.item2 ?? [];
        List<SavedInValueItem> newlist = [];
        newlist.addAll(classes.map((it) => SavedInValueItem(
            id: it.id,
            name: it.getName(),
            color: it.getDesign().primary,
            type: SavedInType.CLASS)));
        newlist.addAll(courses.map((it) => SavedInValueItem(
            id: it.id,
            name: it.getName(),
            color: it.getDesign()?.primary,
            type: SavedInType.COURSE)));
        return newlist;
      }),
      builder: (context, SavedInValueItem item) => ListTile(
            leading: Icon(
              Icons.widgets,
              color: item.color,
            ),
            title: Text(item.name),
            onTap: () {
              selected = item;
              Navigator.pop(context);
            },
          ),
      actions: (context) => [
            RButton(
                onTap: () {
                  showNewCourseSheet(context, database);
                },
                iconData: Icons.add,
                text: getString(context).newcourse.toUpperCase()),
          ]).then((value) {
    return Future.value(selected);
  });
}

Future<String?> selectDateString(
  BuildContext context,
  String? currentDate,
) {
  return showDatePicker(
          context: context,
          initialDate:
              currentDate != null ? parseDate(currentDate) : DateTime.now(),
          firstDate: DateTime.utc(2018, 01, 01),
          lastDate: DateTime.utc(2029, 01, 01))
      .then((newDateTime) {
    if (newDateTime == null) return null;
    return parseDateString(newDateTime);
  });
}
