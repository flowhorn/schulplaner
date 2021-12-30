import { SchulplanerReferences } from "../schulplaner_globals";


export async function removeNotificationReminder(memberId: string) {
    await SchulplanerReferences.notificationsCollection.doc(memberId).set({
        'notifydaily': false,
        'devices': {},
    }, { merge: true, });
}