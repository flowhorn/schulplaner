import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_member_sheet.dart';
import 'package:schulplaner8/profile/user_image_view.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner8/models/user.dart';

class SchoolClassMemberView extends StatelessWidget {
  final String schoolClassID;
  final PlannerDatabase database;
  SchoolClassMemberView({
    required this.schoolClassID,
    required this.database,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SchoolClass?>(
      builder: (context, snapshot) {
        SchoolClass? schoolClassInfo = snapshot.data;
        if (schoolClassInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Design? courseDesign = schoolClassInfo.getDesign();
        return Theme(
            data: newAppThemeDesign(context, courseDesign),
            child: Scaffold(
              appBar: MyAppHeader(
                  title:
                      '${getString(context).members} ${getString(context).in_} ' +
                          schoolClassInfo.getName()),
              body: ListView(
                children: schoolClassInfo.membersData.values.map((memberData) {
                  String memberuid = memberData.getUid();
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    builder: (context, snapshot) {
                      Map<String, dynamic>? data = snapshot.data?.data();
                      UserProfile? userProfile =
                          data != null ? UserProfile.fromData(data) : null;
                      return CourseMemberTile(
                        isMe: memberData.id == database.getMemberId(),
                        userProfile: userProfile,
                        memberData: memberData,
                        onTap: () {},
                        onLongPress: () {
                          showConfirmDialog(
                                  context: context,
                                  title: bothlang(context,
                                      de: 'Nutzer melden', en: 'Report User'))
                              .then((result) {
                            if (result == true) {
                              FirebaseFirestore.instance
                                  .collection('reports')
                                  .doc()
                                  .set({
                                'uID': memberData.id,
                                'type': 'course-member',
                                'isNewReport': true,
                              });
                            }
                          });
                        },
                        onTrailing: () {
                          if (memberData.id == database.getMemberId()) return;
                          _showMemberSheet(
                            context: context,
                            schoolClassId: schoolClassID,
                            database: database,
                            memberData: memberData,
                            userProfile: userProfile,
                          );
                        },
                      );
                    },
                    future: database.dataManager.getMemberInfo(memberuid).get(),
                  );
                }).toList(),
              ),
            ));
      },
      stream: database.schoolClassInfos.getItemStream(schoolClassID),
    );
  }
}

class CourseMemberTile extends StatelessWidget {
  final bool isMe;
  final UserProfile? userProfile;
  final MemberData memberData;
  final VoidCallback onTap, onTrailing, onLongPress;

  const CourseMemberTile({
    Key? key,
    this.userProfile,
    required this.memberData,
    required this.onTap,
    required this.onTrailing,
    required this.onLongPress,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserImageView(
        userProfile: userProfile,
      ),
      title: Text(userProfile?.name ?? getString(context).anonymoususer),
      trailing: IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: onTrailing,
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SchoolClassMemberRoleCard(memberRole: memberData.role),
          if (isMe)
            Card(
              color: Colors.teal,
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  bothlang(context, de: 'Ich', en: 'Me'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
        ],
      ),
      onLongPress: onLongPress,
    );
  }
}

Future<void> _showMemberSheet({
  required BuildContext context,
  required String schoolClassId,
  required PlannerDatabase database,
  UserProfile? userProfile,
  required MemberData memberData,
}) {
  final memberSheet = SchoolClassMemberSheet(
    schoolClassId: schoolClassId,
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
      routname: 'memberid');
}

class SchoolClassMemberRoleCard extends StatelessWidget {
  final MemberRole? memberRole;
  const SchoolClassMemberRoleCard({Key? key, this.memberRole})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (memberRole == MemberRole.admin || memberRole == MemberRole.owner) {
      return Card(
        color: Colors.redAccent,
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            getString(context).admin,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (memberRole == MemberRole.creator) {
      return Card(
        color: Colors.orange,
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            bothlang(context, de: 'Ersteller', en: 'Creator'),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Container();
  }
}
