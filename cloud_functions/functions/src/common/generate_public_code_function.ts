import * as functions from 'firebase-functions';
import { DynamicLinksLogic } from '../dynamic_links/dynamic_links';
import { firestore } from '../schulplaner_globals';
import { generateRandomString } from './random_string';

export const generatePublicCodeFunction = functions.https.onCall(async (data, context) => {
    return generatePublicCodeInner(data.codetype, data.id);
});

export async function generatePublicCodeInner(codetype: number, id: string,) {
    try {
        let attempt: number = 0;
        while (attempt < 10) {
            const randomCode = generateRandomString();
            const dynamicLink: string | null = await DynamicLinksLogic.getJoinLink(randomCode, "???");
            const generatedCode = {
                codetype: codetype,
                referredid: id,
                publiccode: randomCode,
                link: dynamicLink,
            };
            const docSnapshot = await firestore.collection('publiccodes')
                .doc(generatedCode.publiccode).get();
            if (docSnapshot.exists) {
                attempt++;
                break;
            } else {
                if (generatedCode.codetype === 0) {
                    await firestore.collection('courses').doc(generatedCode.referredid)
                        .set({
                            'publiccode': generatedCode.publiccode,
                            'joinLink': generatedCode.link,
                        }, { merge: true });
                    await docSnapshot.ref.set(generatedCode);
                } else if (generatedCode.codetype === 1) {
                    await firestore.collection('schoolclasses').doc(generatedCode.referredid)
                        .set({
                            'publiccode': generatedCode.publiccode,
                            'joinLink': generatedCode.link,
                        }, { merge: true });
                    await docSnapshot.ref.set(generatedCode);
                }
                console.log("Successful code generation:" + generatedCode.publiccode);
                return generatedCode;
            }
        }
        console.log("Error code generation1");
        return Error("NO CODE GENERATION POSSIBLE: EXCEEDED ATTEMPTS!!");
    } catch (e) {
        console.log("Error code generation2");
        console.log(e);
        return e;
    }
}