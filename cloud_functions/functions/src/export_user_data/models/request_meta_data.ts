import { firestore } from "firebase-admin";

export class RequestMetaData {
    public downloadUrl: string;
    public totalBytes: number;
    public expiresOn: firestore.Timestamp;


    constructor(params: {
        downloadUrl: string,
        totalBytes: number,
        expiresOn: firestore.Timestamp
    }) {
        this.downloadUrl = params.downloadUrl;
        this.totalBytes = params.totalBytes;
        this.expiresOn = params.expiresOn;
    }

}