import { SchulplanerReferences } from "../schulplaner_globals";


export async function removeServerRequest(requestId: string) {
    await SchulplanerReferences.serverRequests.doc(requestId).delete();
}