import { UserId } from "../../user/models/user_id";
import { CourseGateway } from "../logic/course_gateway";
import { SchoolClassGateway } from "../logic/school_class_gateway";
import { CourseData } from "../models/course_data";
import { GroupId } from "../models/group_id";

export interface SchoolClassRemoveCourseParams {
    schoolClassId: GroupId,
    courseId: GroupId,
    userId: UserId,
    courseData: CourseData,
}

export class SchoolClassRemoveCourseHandler {

    constructor(private courseGateway: CourseGateway, private schoolClassGateway: SchoolClassGateway) { ; }

    async handle(params: SchoolClassRemoveCourseParams): Promise<boolean> {
        await this.courseGateway.removeConnectedClassToCourse(params.schoolClassId, params.courseId, params.courseData);
        await this.schoolClassGateway.removeConnectedCourseToClass(params.schoolClassId, params.courseId);
        return true;
    }
}