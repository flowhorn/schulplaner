import { UserId } from "../../user/models/user_id";
import { CourseGateway } from "../logic/course_gateway";
import { SchoolClassGateway } from "../logic/school_class_gateway";
import { CourseData } from "../models/course_data";
import { GroupId } from "../models/group_id";


export interface SchoolClassAddCourseParams {
    schoolClassId: GroupId,
    courseId: GroupId,
    userId: UserId,
    courseData: CourseData,
}

export class SchoolClassAddCourseHandler {

    constructor(private courseGateway: CourseGateway, private schoolClassGateway: SchoolClassGateway) { ; }

    async handle(params: SchoolClassAddCourseParams): Promise<boolean> {
        await this.courseGateway.addConnectedClassToCourse(params.schoolClassId, params.courseId, params.courseData);
        await this.schoolClassGateway.addConnectedCourseToClass(params.schoolClassId, params.courseId);
        return true;
    }
}