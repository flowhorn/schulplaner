import * as admin from "firebase-admin";
import { GroupId } from "./groups/models/group_id";
import { MemberId } from "./user/models/member_id";
import { UserId } from "./user/models/user_id";

export const firebaseApp = admin.initializeApp();

export const europeRegion = 'europe-west3';

export const firestore = firebaseApp.firestore();
export const firebaseMessaging = firebaseApp.messaging();
const settings = { timestampsInSnapshots: true };
firestore.settings(settings);

export class SchulplanerReferences {

    static firestoreReference = firestore;
    static coursesCollection = firestore.collection('courses');
    static serverRequests = firestore.collection('ServerRequests');
    static notificationsCollection = firestore.collection('notifications');
    static usersCollection = firestore.collection('users');
    static schoolClassesCollection = firestore.collection('schoolclasses');

    static getCourseDocument(groupId: GroupId) {
        return this.coursesCollection.doc(groupId.id);
    }

    static getSchoolClassDocument(groupId: GroupId) {
        return this.schoolClassesCollection.doc(groupId.id);
    }

    static getUsersDocument(userId: UserId) {
        return this.usersCollection.doc(userId.uid);
    }

    static getUsersInfoDocument(userId: UserId) {
        return this.usersCollection.doc(userId.uid).collection('Data').doc('Info');
    }

    static getPlannersDocument(memberId: MemberId) {
        return this.getUsersDocument(memberId.userId).collection('planner').doc(memberId.plannerId);
    }

    static getConnectionsDocument(memberId: MemberId) {
        return this.getPlannersDocument(memberId).collection('data').doc('connections');
    }

}