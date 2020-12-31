import { MemberId } from "../../user/models/member_id";
import { CourseGateway } from "../logic/course_gateway";
import { SchoolClassGateway } from "../logic/school_class_gateway";
import { GroupId } from "../models/group_id";
import { GroupType } from "../models/group_type";
import { MemberRole } from "../models/member_role";

export interface UpdateMemberRoleParams {
    myMemberId: MemberId | null,
    groupId: GroupId,
    groupType: GroupType,
    memberId: MemberId,
    newRole: MemberRole,
}

export class UpdateMemberRoleHandler {

    constructor(private courseGateway: CourseGateway, private schoolClassGateway: SchoolClassGateway) { ; }

    async handle(params: UpdateMemberRoleParams): Promise<boolean> {
        if (params.groupType === GroupType.course) {
            await this.courseGateway.updateMemberRole(params.memberId, params.groupId, params.newRole);
            return true;
        }
        if (params.groupType === GroupType.schoolClass) {
            await this.schoolClassGateway.updateMemberRole(params.memberId, params.groupId, params.newRole);
            return true;
        }
        return false;
    }
}