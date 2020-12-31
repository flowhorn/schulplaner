import * as functions from 'firebase-functions';
import { firestore } from '../schulplaner_globals';

export const onUserCreatedFunction = functions.auth.user().onCreate(async (firebaseUser, context) => {
    const userID = firebaseUser.uid;
    const plannerReference = firestore.collection("users").doc(userID).collection("planner");
    const newPlannerID = plannerReference.doc().id;
    await plannerReference.doc(newPlannerID).set({
        'id': newPlannerID,
        'archived': false,
        "deleted": false,
        "name": "Schulplaner",
        "uid": userID,
    });
    try {
        await firestore.collection("users").doc(userID).set(
            {
                "id": userID,
                "name": firebaseUser.displayName || null,
            },
        );
    } catch (e) {
        console.log(e);
    }

});