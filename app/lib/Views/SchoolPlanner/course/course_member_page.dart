import 'package:bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/profile/user_image_view.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/models/user.dart';

import 'course_member_sheet.dart';

class CourseMemberView extends StatelessWidget {
  final String courseID;
  CourseMemberView({@required this.courseID});
  @override
  Widget build(BuildContext context) {
    final database =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    return StreamBuilder<Course>(
      builder: (context, snapshot) {
        Course courseInfo = snapshot.data;
        if (courseInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Design courseDesign = courseInfo?.getDesign();
        return Theme(
            data: newAppThemeDesign(context, courseDesign),
            child: Scaffold(
              appBar: MyAppHeader(
                  title:
                      '${getString(context).members} ${getString(context).in_} ' +
                          courseInfo.getName()),
              body: ListView(
                children: [
                  for (final memberData in courseInfo.membersData.values)
                    _MemberItem(
                      courseId: courseID,
                      memberData: memberData,
                    ),
                ],
              ),
            ));
      },
      stream: database.courseinfo.getItemStream(courseID),
    );
  }
}

class _MemberItem extends StatelessWidget {
  final String courseId;
  final MemberData memberData;

  const _MemberItem({
    Key key,
    @required this.memberData,
    @required this.courseId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    String memberuid = memberData.getUid();
    return FutureBuilder<DocumentSnapshot>(
        future: database.dataManager.getMemberInfo(memberuid).get(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          UserProfile userProfile =
              data != null ? UserProfile.fromData(data) : null;
          return CourseMemberTile(
            isMe: memberData.id == database.getMemberId(),
            userProfile: userProfile,
            memberData: memberData,
            onTap: () {},
            onLongPress: () {
              _tryReportMember(context);
            },
            onTrailing: () {
              if (memberData.id == database.getMemberId()) return;
              _showMemberSheet(
                context: context,
                courseId: courseId,
                database: database,
                memberData: memberData,
                userProfile: userProfile,
              );
            },
          );
        });
  }

  void _tryReportMember(BuildContext context) async {
    final result = await showConfirmDialog(
        context: context,
        title: bothlang(context, de: 'Nutzer melden', en: 'Report user'));

    if (result == true) {
      await FirebaseFirestore.instance.collection('reports').doc().set({
        'uID': memberData.id,
        'type': 'course-member',
        'isNewReport': true,
      });
    }
  }
}

class CourseMemberTile extends StatelessWidget {
  final bool isMe;
  final UserProfile userProfile;
  final MemberData memberData;
  final VoidCallback onTap, onTrailing, onLongPress;

  const CourseMemberTile({
    Key key,
    this.userProfile,
    this.memberData,
    this.onTap,
    this.onTrailing,
    this.onLongPress,
    this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserImageView(
        userProfile: userProfile,
      ),
      title: Text(userProfile?.name ?? getString(context).anonymoususer),
      trailing: isMe
          ? null
          : IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: onTrailing,
            ),
      subtitle: Row(
        children: <Widget>[
          CourseMemberRoleCard(memberRole: memberData.role),
          if (isMe)
            Card(
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  bothlang(context, de: 'Ich', en: 'Me'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: Colors.teal,
            )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      onLongPress: onLongPress,
    );
  }
}

Future<void> _showMemberSheet(
    {@required BuildContext context,
    @required String courseId,
    @required PlannerDatabase database,
    @required UserProfile userProfile,
    @required MemberData memberData}) {
  final memberSheet = CourseMemberSheet(
    courseId: courseId,
    database: database,
    memberData: memberData,
    userProfile: userProfile,
  );
  return showSheetBuilder(
    context: context,
    child: (context) {
      return memberSheet.build(context);
    },
    title: userProfile?.name ?? getString(context).anonymoususer,
    routname: 'memberid',
  );
}

class CourseMemberRoleCard extends StatelessWidget {
  final MemberRole memberRole;
  const CourseMemberRoleCard({Key key, this.memberRole}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (memberRole.isAdminOrOwner()) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            getString(context).admin,
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.redAccent,
      );
    } else if (memberRole == MemberRole.creator) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            bothlang(context, de: 'Ersteller', en: 'Creator'),
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.orange,
      );
    }
    return Container();
  }
}
