import * as functions from 'firebase-functions';
import { europeRegion } from '../../schulplaner_globals';
import { UserGateway } from '../../user/gateway/user_gateway';
import { MemberId } from '../../user/models/member_id';
import { RemoveMemberFromGroupParams, RemoveMemberFromGroupsHandler } from '../handler/remove_member_from_group_handler';
import { CourseGateway } from '../logic/course_gateway';
import { SchoolClassGateway } from '../logic/school_class_gateway';
import { GroupId } from '../models/group_id';
import { GroupType, GroupTypeConverter } from '../models/group_type';


export const removeMemberFromGroupFunction = functions.region(europeRegion).https.onCall(async (data, context) => {
    const myMemberId: MemberId = MemberId.fromMemberString(data.myMemberId);
    const memberId: MemberId = MemberId.fromMemberString(data.memberId);
    const groupId: GroupId = new GroupId(data.groupId);
    const groupType: GroupType = GroupTypeConverter.fromData(data.groupType);

    if (myMemberId.userId.uid === context.auth?.uid) {
        const userGateway = new UserGateway();
        const handler = new RemoveMemberFromGroupsHandler(
            new CourseGateway(userGateway),
            new SchoolClassGateway(userGateway),
        );
        const params: RemoveMemberFromGroupParams = {
            myMemberId: myMemberId,
            memberId: memberId,
            groupId: groupId,
            groupType: groupType,
        };
        return await handler.handle(params);
    }
    return false;
});