import { MemberId } from "../../user/models/member_id";
import { CourseGateway } from "../logic/course_gateway";
import { SchoolClassGateway } from "../logic/school_class_gateway";
import { GroupId } from "../models/group_id";
import { GroupType } from "../models/group_type";

export interface JoinGroupParams {
    myMemberId: MemberId,
    groupId: GroupId,
    groupType: GroupType,
}

export class JoinGroupHandler {

    constructor(private courseGateway: CourseGateway, private schoolClassGateway: SchoolClassGateway) { ; }

    async handle(params: JoinGroupParams): Promise<boolean> {
        if (params.groupType === GroupType.course) {
            const isV3MemberInCourse = await this.courseGateway.isMemberInCourseV3(params.groupId, params.myMemberId.userId);
            if (isV3MemberInCourse) return false;
            await this.courseGateway.addMemberDataFromCourse(params.myMemberId, params.groupId);
            await this.courseGateway.addCourseFromConnectionsData(params.myMemberId, params.groupId);
            return true;
        }
        if (params.groupType === GroupType.schoolClass) {
            const isV3MemberInSchoolClass = await this.schoolClassGateway.isMemberInSchoolClassV3(params.groupId, params.myMemberId.userId);
            if (isV3MemberInSchoolClass) return false;
            await this.schoolClassGateway.addMemberDataFromSchoolClass(params.myMemberId, params.groupId);
            await this.schoolClassGateway.addSchoolClassFromConnectionsData(params.myMemberId, params.groupId);
            return true;
        }
        return false;
    }
}