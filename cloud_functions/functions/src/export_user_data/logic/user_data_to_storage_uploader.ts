import { storage, firestore } from 'firebase-admin';
import { RequestMetaData } from '../models/request_meta_data';

export class UserDataToStorageUploader {
    public firebaseStorage: storage.Storage;
    constructor(params: {
        firebaseStorage: storage.Storage,
    }) {
        this.firebaseStorage = params.firebaseStorage;
    }

    async upload(requestId: string, archive: Buffer): Promise<RequestMetaData | null> {
        const file = this.firebaseStorage.bucket('mainprojects-32581-user-exports').file(requestId + ".zip");
        await file.save(archive);
        const expiresTimestamp = firestore.Timestamp.fromMillis(
            firestore.Timestamp.now().toMillis() + (28 * 7 * 3600000)
        );
        const signedUrl = (await file.getSignedUrl({
            action: 'read',
            expires: expiresTimestamp.toMillis(),
        }))[0];
        return new RequestMetaData({
            downloadUrl: signedUrl,
            totalBytes: archive.length,
            expiresOn: expiresTimestamp,
        });
    }
}