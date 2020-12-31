import * as admin from 'firebase-admin';
import { firebaseMessaging } from "../schulplaner_globals";

export
    async function sendNotificationToUser(notifactiondata: admin.firestore.DocumentSnapshot, title: string, body: string, data: string): Promise<boolean> {
    const notificationdevices = notifactiondata.data().devices;
    for (const key of Object.keys(notificationdevices)) {
        const device = notificationdevices[key];
        if (device == null) break;
        if (device.enabled === true) {
            const message = {
                notification: {
                    title: title,
                    body: body,
                },
                token: key
            };
            if (data != null) message['data'] = data;
            await firebaseMessaging.send(message).then((response) => {
                // Response is a message ID string.
                console.log('Successfully sent message:', response);
            })
                .catch((error) => {
                    console.log('Error sending message:', error);
                });
            ;
        }
    }
    return true;
}
