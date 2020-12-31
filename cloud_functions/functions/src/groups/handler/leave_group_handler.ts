import { MemberId } from "../../user/models/member_id";
import { CourseGateway } from "../logic/course_gateway";
import { SchoolClassGateway } from "../logic/school_class_gateway";
import { GroupId } from "../models/group_id";
import { GroupType } from "../models/group_type";

export interface LeaveGroupParams {
    myMemberId: MemberId,
    groupId: GroupId,
    groupType: GroupType,
}

export class LeaveGroupHandler {

    constructor(private courseGateway: CourseGateway, private schoolClassGateway: SchoolClassGateway) { ; }

    async handle(params: LeaveGroupParams): Promise<boolean> {
        if (params.groupType === GroupType.course) {
            await this.courseGateway.removeMemberDataFromCourse(params.myMemberId, params.groupId);
            await this.courseGateway.removeCourseFromConnectionsData(params.myMemberId, params.groupId);
            return true;
        }
        if (params.groupType === GroupType.schoolClass) {
            await this.schoolClassGateway.removeMemberDataFromSchoolClass(params.myMemberId, params.groupId);
            await this.schoolClassGateway.removeSchoolClassFromConnectionsData(params.myMemberId, params.groupId);
            return true;
        }
        return false;
    }
}