import * as functions from 'firebase-functions';
import { firestore } from './schulplaner_globals';

export const courseReference = firestore.collection("courses");
export const classReference = firestore.collection("schoolclasses");
export const userReference = firestore.collection("users");

export enum FirestoreWriteType {
    create, edit, delete
}

export function getWriteType(before: functions.firestore.DocumentSnapshot, after: functions.firestore.DocumentSnapshot) {
    if (before.exists && after.exists) {
        return FirestoreWriteType.edit;
    } else if (before.exists && !after.exists) {
        return FirestoreWriteType.delete;
    } else if (!before.exists && after.exists) {
        return FirestoreWriteType.create;
    }
    throw Error("FirestoreWriteType Error");
}

export function getMapItem(key: string, value: any) {
    const map = {};
    map[key] = value;
    return map;
}

export function getClassDocument(classID: string) {
    return classReference.doc(classID);
}
export function getCourseDocument(courseID: string) {
    return courseReference.doc(courseID);
}

export function getUserDocument(uid: string) {
    return userReference.doc(uid);
}