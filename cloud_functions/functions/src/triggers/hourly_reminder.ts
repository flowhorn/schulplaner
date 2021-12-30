import * as functions from 'firebase-functions';
import admin = require('firebase-admin');
import { firestore, europeRegion } from '../schulplaner_globals';
import { sendDailyNotification } from '../homework_reminder/send_daily_notification';
import { addServerRequest, ServerRequestTypes } from '../server_requests/add_server_request';


export const hourlyReminderFunction = functions.region(europeRegion).runWith({
    memory: '2GB',
    timeoutSeconds: 540,
}).pubsub.schedule('every 60 minutes from 00:00 to 23:55').onRun(async (context) => {
    try {
        const currenttime = getCurrentUtcTime();
        console.log("Loading Push-Notification for CurrentTime:" + currenttime);
        const results = await firestore.collection("notifications")
            .where("notifydaily", "==", true)
            .where("dailytime", "==", currenttime)
            .get();
        console.log("Notify " + results.size.toString() + " Users");
        const promises = [];
        for (const notifydoc of results.docs) {
            const devicesOfNotifyDoc = notifydoc.data().devices;
            const memberId = notifydoc.id;
            if (devicesOfNotifyDoc == null || devicesOfNotifyDoc == {}) {
                console.log("Empty Notifications Devices!");
                promises.push(addServerRequest(ServerRequestTypes.REMOVE_NOTIFICATION_REMINDER, { 'id': memberId }));
            } else {
                promises.push(sendDailyNotification(memberId, notifydoc));
            }

        }
        await Promise.all(promises);
        console.log("Notifications finished!");
        return true;
    } catch (e) {
        console.log(e);
        return false;
    }
});



function getCurrentUtcTime(): string {
    function getCurrentHours() {
        const hours = admin.firestore.Timestamp.now().toDate().getHours() + 1;
        if (hours === 24) return 0;
        else return hours;
    }
    const currentHours = getCurrentHours();
    return (("0" + currentHours).slice(-2) + ":00");
}