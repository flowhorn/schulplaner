import * as functions from 'firebase-functions';
import { UserGateway } from '../../user/gateway/user_gateway';
import { UserId } from '../../user/models/user_id';
import { SchoolClassRemoveCourseHandler, SchoolClassRemoveCourseParams } from '../handler/school_class_remove_course_handler';
import { CourseGateway } from '../logic/course_gateway';
import { SchoolClassGateway } from '../logic/school_class_gateway';
import { GroupId } from '../models/group_id';

export const schoolClassRemoveCourseFunction = functions.https.onCall(async (data, context) => {
    try {
        const schoolClassId = new GroupId(data.classid);
        const courseId = new GroupId(data.courseid);
        const userId = new UserId(context.auth.uid);

        const userGateway = new UserGateway();
        const courseGateway = new CourseGateway(userGateway);
        const handler = new SchoolClassRemoveCourseHandler(
            courseGateway,
            new SchoolClassGateway(userGateway),
        );

        const courseData = await courseGateway.getCourseData(courseId);
        const params: SchoolClassRemoveCourseParams = {
            courseId: courseId,
            schoolClassId: schoolClassId,
            userId: userId,
            courseData: courseData,
        };
        return await handler.handle(params);
    } catch (e) {
        return e;
    }
});