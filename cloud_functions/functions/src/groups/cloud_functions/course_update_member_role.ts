import * as functions from 'firebase-functions';
import { UserGateway } from '../../user/gateway/user_gateway';
import { MemberId } from '../../user/models/member_id';
import { UpdateMemberRoleHandler, UpdateMemberRoleParams } from '../handler/update_member_role_handler';
import { CourseGateway } from '../logic/course_gateway';
import { SchoolClassGateway } from '../logic/school_class_gateway';
import { GroupId } from '../models/group_id';
import { GroupType } from '../models/group_type';
import { MemberRoleConverter } from '../models/member_role';

export const courseUpdateMemberRoleFunction = functions.https.onCall(async (data, context) => {

    const courseId = new GroupId(data.courseID);
    const memberId = MemberId.fromMemberString(data.memberID);
    const newRole = MemberRoleConverter.fromData(data.newRole);

    //if (myMemberId.userId.uid === context.auth?.uid) {
    const userGateway = new UserGateway();
    const handler = new UpdateMemberRoleHandler(
        new CourseGateway(userGateway),
        new SchoolClassGateway(userGateway),
    );
    const params: UpdateMemberRoleParams = {
        myMemberId: null,
        memberId: memberId,
        groupId: courseId,
        groupType: GroupType.course,
        newRole: newRole,
    };
    return await handler.handle(params);
    // }
    //return false;
});