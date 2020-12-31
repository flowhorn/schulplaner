import * as functions from 'firebase-functions';
import { UserGateway } from '../../user/gateway/user_gateway';
import { UserId } from '../../user/models/user_id';
import { SchoolClassAddCourseHandler, SchoolClassAddCourseParams } from '../handler/school_class_add_course_handler';
import { CourseGateway } from '../logic/course_gateway';
import { SchoolClassGateway } from '../logic/school_class_gateway';
import { GroupId } from '../models/group_id';

export const schoolClassAddCourseFunction = functions.https.onCall(async (data, context) => {
    try {
        const schoolClassId = new GroupId(data.classid);
        const courseId = new GroupId(data.courseid);
        const userId = new UserId(context.auth.uid);

        const userGateway = new UserGateway();
        const courseGateway = new CourseGateway(userGateway);
        const handler = new SchoolClassAddCourseHandler(
            courseGateway,
            new SchoolClassGateway(userGateway),
        );

        const courseData = await courseGateway.getCourseData(courseId);
        if (courseData.sizeOfConnectedClasses() >= 3) {
            console.log('Course has already 3 connected classes. Function therefore fails!')
            return false;
        }

        const params: SchoolClassAddCourseParams = {
            courseId: courseId,
            schoolClassId: schoolClassId,
            userId: userId,
            courseData: courseData,
        };
        return await handler.handle(params);
    } catch (e) {
        console.log(e);
        return e;
    }
});