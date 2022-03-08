import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Courses.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/course_page.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class CourseList extends StatelessWidget {
  CourseList();
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return Scaffold(
      body: StreamBuilder<Map<String, Course>>(
        stream: plannerDatabase.courseinfo.stream,
        initialData: plannerDatabase.courseinfo.data,
        builder: (context, snapshot) {
          final courselist = (snapshot.data ?? {}).values.toList()
            ..sort(
                (item1, item2) => item1.getName().compareTo(item2.getName()));
          return UpListView<Course>(
            items: courselist,
            emptyViewBuilder: (context) => EmptyListState(),
            builder: (context, courseInfo) {
              return _CourseTile(courseInfo: courseInfo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNewCourseSheet(context, plannerDatabase);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  final Course? courseInfo;

  const _CourseTile({Key? key, this.courseInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    if (courseInfo == null || courseInfo?.id == null) {
      return SizedBox(
        height: 52.0,
        child: ListTile(
          title: Text('Leeres KursObjekt geladen!'),
        ),
      );
    }
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Hero(
            tag: 'courestag:' + courseInfo!.id,
            child: ColoredCircleText(
                text:
                    toShortNameLength(context, courseInfo!.getShortname_full()),
                color: courseInfo!.getDesign()!.primary,
                radius: 22.0)),
      ),
      title: Text(courseInfo!.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            getString(context).teacher + ': ' + courseInfo!.getTeachersListed(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(getString(context).place + ': ' + courseInfo!.getPlacesListed()),
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () {
            showCourseMoreSheet(
              context,
              courseid: courseInfo!.id,
              plannerdatabase: plannerDatabase!,
            );
          }),
      onTap: () {
        pushWidget(
          context,
          CourseView(
            courseid: courseInfo!.id,
            database: plannerDatabase!,
          ),
          routname: 'course',
        );
      },
    );
  }
}
