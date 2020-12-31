import admin = require("firebase-admin");
import { firestore } from "../schulplaner_globals";
import { getCoursesOfUser } from "./get_courses";

export async function loadSchoolTasksForUser(memberid: string, days: number, includeToday: boolean) {
    const today = admin.firestore.Timestamp.fromMillis(
        admin.firestore.Timestamp.now().toMillis() + (86400000 * (includeToday === true ? 0 : 1))
    ).toDate().toISOString().substring(0, 10);
    const lastday = admin.firestore.Timestamp.fromMillis(
        admin.firestore.Timestamp.now().toMillis() + (86400000 * days)
    ).toDate().toISOString().substring(0, 10);
    const uid = memberid.split("::")[0];
    const plannerid = memberid.split("::")[1];
    const plannerref = firestore.collection("users").doc(memberid.split("::")[0]).collection("planner")
        .doc(memberid.split("::")[1]);

    const courses = await getCoursesOfUser(uid, plannerid);
    const tasks = new Array();
    const loadtaskpromises: Array<Promise<admin.firestore.QuerySnapshot>> = [];
    if (courses != null) {
        for (const courseId of courses) {
            loadtaskpromises.push(firestore.collection("courses").doc(courseId).collection("tasks")
                .where("due", ">=", today)
                .where("due", "<=", lastday)
                .get());
        }
    }
    loadtaskpromises.push(
        plannerref.collection("tasks")
            .where("due", ">=", today)
            .where("due", "<=", lastday).get()
    );
    const allloaders = await Promise.all(loadtaskpromises);

    for (const snap of allloaders) {
        snap.docs.forEach((docsnap) => {
            tasks.push(docsnap.data());
        })
    }
    return tasks;
}