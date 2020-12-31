import { firestore } from "../schulplaner_globals";

export async function getCoursesOfUser(uid: string, plannerid: string) {
    const connectionsData = (await firestore.collection("users").doc(uid).collection("planner").doc(plannerid)
        .collection("data").doc("connections").get()).data();
    if (connectionsData == null) return null;
    const mycourses: Array<string> = [];
    if (connectionsData.mycourses != null) {
        for (const courseId of Object.keys(connectionsData.mycourses)) {
            if (connectionsData.mycourses[courseId] != null) {
                mycourses.push(courseId);
            }
        }
    }

    if (connectionsData.myclasses != null) {
        for (const classid of Object.keys(connectionsData.myclasses)) {
            if (connectionsData.myclasses[classid] != null) {
                const classdata = await firestore.collection("schoolclasses").doc(classid).get()
                if (classdata.exists) {
                    if (classdata.data().courses != null) {
                        for (const courseId of Object.keys(classdata.data().courses)) {
                            if (classdata.data().courses[courseId] != null) {
                                if (mycourses.indexOf(courseId) === -1) mycourses.push(courseId);
                            }
                        }
                    }
                }
            }

        }
    }
    return mycourses;
}