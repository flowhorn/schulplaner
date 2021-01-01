import * as admin from 'firebase-admin';
import { loadSchoolTasksForUser } from './load_tasks';
import { isTaskFinished } from './is_task_finished';
import { notFinishedTasks } from './not_finished';
import { firebaseMessaging } from '../schulplaner_globals';

export async function sendDailyNotification(memberid: string, notifactiondata: admin.firestore.DocumentSnapshot): Promise<boolean> {
    try {
        //var uid = memberid.split('::')[0];
        //var plannerid = memberid.split('::')[1];
        const notificationdevices = notifactiondata.data().devices;
        let tasks = await loadSchoolTasksForUser(memberid, notifactiondata.data().dailydaterange, false);
        if (tasks == null) tasks = [];
        const undonetasks: Array<any> = notFinishedTasks(memberid, tasks);

        let bodyText = "";
        for (const task of tasks) {
            const isfinished = isTaskFinished(memberid, task);
            if (isfinished)
                bodyText += ("\n" + "(✓) " + (task.title || ""));
            else bodyText += ("\n" + (task.title || ""));
        }

        for (const key of Object.keys(notificationdevices)) {
            const device = notificationdevices[key];
            if (device == null) break;
            if (device.enabled === true) {
                const messageData = {
                    notdata: notifactiondata.data().toString(),
                    memberid: memberid,
                };
                const notificationTitle = tasks.length === 0 ? ("Keine anstehenden Hausaufgaben") :
                    (tasks.length.toString() + ' anstehende Hausaufgaben (davon ' + undonetasks.length.toString() + ' zu erledigen)');

                const message = {
                    'notification': {
                        title: notificationTitle,
                        body: bodyText
                    },
                    'token': key,
                    'data': messageData,
                };

                await firebaseMessaging.send(message).then((response) => {
                    // Response is a message ID string.
                    console.log('Successfully sent message: ' + response);
                }).catch((error) => {
                    console.log('Error sending message: ' + error);
                });
            }
        }
        return true;
    } catch (e) {
        console.log("Unexpected Error!");
        console.log(e);
        return false;
    }

}