import * as functions from 'firebase-functions';
import { DynamicLinksLogic } from './dynamic_links/dynamic_links';
import { onUserCreatedFunction } from './triggers/on_user_created';
import { generatePublicCodeInner, generatePublicCodeFunction } from './common/generate_public_code_function';
import { hourlyReminderFunction } from './triggers/hourly_reminder';
import { firestore } from './schulplaner_globals';
import { sendNotificationToUser } from './homework_reminder/send_notification_to_user';
import { removeMemberFromGroupFunction } from './groups/cloud_functions/remove_member_from_group';
import { leaveGroupFunction } from './groups/cloud_functions/leave_group';
import { joinGroupFunction } from './groups/cloud_functions/join_group';
import { courseUpdateMemberRoleFunction } from './groups/cloud_functions/course_update_member_role';
import { schoolClassUpdateMemberRoleFunction } from './groups/cloud_functions/school_class_update_member_role';
import { schoolClassAddCourseFunction } from './groups/cloud_functions/school_class_add_course';
import { schoolClassRemoveCourseFunction } from './groups/cloud_functions/school_class_remove_course';


export const onCourseCreated = functions.firestore.document("courses/{id}").onCreate(async (snapshot, context) => {
    const id = snapshot.id;
    const currentpubliccode = snapshot.get("publiccode");
    if (currentpubliccode === "" || currentpubliccode == null) {
        return generatePublicCodeInner(0, id);
    }
    return true;
});

export const onSchoolClassCreated = functions.firestore.document("schoolclasses/{id}").onCreate(async (snapshot, context) => {
    const id = snapshot.id;
    const currentpubliccode = snapshot.get("publiccode");
    if (currentpubliccode === "" || currentpubliccode == null) {
        return generatePublicCodeInner(1, id);
    }
    return true;
});




export const removePublicCode =
    functions.https.onCall(async (data, context) => {
        try {
            const generatedCode = await {
                codetype: data.codetype,
                referredid: data.id,
            };

            if (generatedCode.codetype === 0) {
                const snapshot = await firestore.collection('courses').doc(generatedCode.referredid).get();
                const publiccode: string = snapshot.data().publiccode;
                await firestore.collection('courses').doc(generatedCode.referredid)
                    .set({
                        'publiccode': null,
                        'joinLink': null,
                    }, { merge: true });
                await firestore.collection('publiccodes').doc(publiccode).delete();
            } else if (generatedCode.codetype === 1) {
                const snapshot_class = await firestore.collection('schoolclasses').doc(generatedCode.referredid).get();
                const publiccode_class: string = snapshot_class.data().publiccode;
                await firestore.collection('schoolclasses').doc(generatedCode.referredid)
                    .set({
                        'publiccode': null,
                        'joinLink': null,
                    }, { merge: true });
                await firestore.collection('publiccodes').doc(publiccode_class).delete();
            }

            return true;
        } catch (e) {
            return e;
        }
    });

export const getPublicCode = functions.https.onCall(async (data, context) => {
    try {
        const publiccode: string = data.publiccode;
        if (publiccode == null || publiccode === "") return null;
        const snapshot = await firestore.collection("publiccodes").doc(publiccode).get();
        if (snapshot.exists) {
            return snapshot.data();
        } else {
            return null;
        }
    } catch (e) {
        return null;
    }
});

export const getCourseInfo = functions.https.onCall(async (data, context) => {
    try {
        const courseid: string = data.courseid;
        if (courseid == null || courseid === "") return null;
        const coursedataref = firestore.collection("courses").doc(courseid);
        const get_courseinfo = coursedataref.get();

        console.log("Loading Data for courseid");
        const results = await Promise.all([get_courseinfo]).catch((error) => {
            console.log(error);
            return error;
        });
        const courseinfodata = results[0].data();
        console.log("Returning value for courseid");
        return {
            courseinfo: courseinfodata,
        };
    } catch (e) {
        return null;
    }
});

export const getSchoolClassInfo = functions.https.onCall(async (data, context) => {
    try {
        const classid: string = data.classid;
        if (classid == null || classid === "") return null;
        const coursedataref = firestore.collection("schoolclasses").doc(classid);
        const get_classinfo = coursedataref.get();
        console.log("Loading Data for classid");
        const results = await Promise.all([get_classinfo]).catch((error) => {
            console.log(error);
            return error;
        });
        const classinfodata = results[0].data();
        console.log("Returning value for classid");
        return {
            classinfo: classinfodata,
        };
    } catch (e) {
        return null;
    }
});

export const userChangeMemberTypeCourse = courseUpdateMemberRoleFunction;
export const userChangeMemberTypeClass = schoolClassUpdateMemberRoleFunction;

export const schoolClassAddCourse = schoolClassAddCourseFunction;
export const schoolClassRemoveCourse = schoolClassRemoveCourseFunction;


async function getdatacourse(courseid: string): Promise<FirebaseFirestore.DocumentData> {
    const coursedataref = firestore.collection("courses").doc(courseid);
    const get_courseinfo = await coursedataref.get();
    return get_courseinfo.data();
}
async function getdataclass(classid: string): Promise<FirebaseFirestore.DocumentData> {
    const classdataref = firestore.collection("schoolclasses").doc(classid);
    const get_classdata = await classdataref.get();
    return get_classdata.data();
}

async function notifynewletter(letter: FirebaseFirestore.DocumentData): Promise<boolean> {
    if (letter.sendpush === true) {
        const members = await getmembersofsavedin(letter.savedin);
        for (const memberid of Object.keys(members)) {
            console.log(memberid);
            const notificationsnap = (await firestore.collection("notifications").doc(memberid).get());
            console.log(notificationsnap);
            if (notificationsnap.exists) {
                await sendNotificationToUser(notificationsnap, letter.title, letter.content, null);
            }
        }
        return true;
    } else return false;
}


async function getmembersofsavedin(savedin: FirebaseFirestore.DocumentData): Promise<FirebaseFirestore.DocumentData> {
    if (savedin.type === 1) {
        return (await getdatacourse(savedin.id)).members;
    } else if (savedin.type === 2) {
        return (await getdataclass(savedin.id)).members;
    }
    return null;
}

export const onlettercreatedcourse = functions
    .firestore.document("courses/{courseid}/letter/{letterid}").onCreate(async (snapshot, context) => {
        await notifynewletter(snapshot.data());
        return true;
    });


export const onlettercreatedschoolclass = functions
    .firestore.document("schoolclasses/{classid}/letter/{letterid}").onCreate(async (snapshot, context) => {
        await notifynewletter(snapshot.data());
        return true;
    });

export const CourseUpdateMemberRole = courseUpdateMemberRoleFunction
export const ClassUpdateMemberRole = schoolClassUpdateMemberRoleFunction;

export const generatePublicCode = generatePublicCodeFunction;
export const hourlyReminder = hourlyReminderFunction;
export const onUserCreated = onUserCreatedFunction;

export const RemoveMemberFromGroup = removeMemberFromGroupFunction;
export const LeaveGroup = leaveGroupFunction;
export const JoinGroup = joinGroupFunction;

export const handleRequests = functions.database.ref("requests/incoming/{requestID}").onCreate(async (snapshot, context) => {
    const data = snapshot.val();
    //const userID = data.userID;
    const type = data.type;
    if (type === "no_course_link") {
        const courseID = data.courseID;
        const course = (await firestore.collection('courses').doc(courseID).get());
        if (course.exists) {
            const publiccode = course.get('publiccode');
            if (course.get("joinLink") == null && publiccode != null) {
                const joinLink = await DynamicLinksLogic.getJoinLink(publiccode, "???");
                await firestore.collection('publiccodes').doc(publiccode).set({}, { merge: true });
                await firestore.collection('courses').doc(courseID).set({
                    'joinLink': joinLink,
                }, { merge: true });
            }
        }
    }
    if (type === "no_class_link") {
        const classID = data.classID;
        const schoolClass = (await firestore.collection('schoolclasses').doc(classID).get());
        if (schoolClass.exists) {
            const publiccode = schoolClass.get('publiccode');
            if (schoolClass.get("joinLink") == null && publiccode != null) {
                const joinLink = await DynamicLinksLogic.getJoinLink(publiccode, "???");
                await firestore.collection('publiccodes').doc(publiccode).set({}, { merge: true });
                await firestore.collection('schoolclasses').doc(classID).set({
                    'joinLink': joinLink,
                }, { merge: true });
            }
        }
    }
});


