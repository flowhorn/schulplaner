import * as admin from "firebase-admin";
import { SchulplanerReferences } from "../../schulplaner_globals";
import { UserId } from "../../user/models/user_id";
import { RequestMetaData } from "../models/request_meta_data";
import { BuildUserDataWorkbook } from "./build_user_data_workbook";
import { ArchiveableFile, FileArchiver } from "./file_archiver";
import { UserDataGateway } from "./user_data_gateway";
import { UserDataToStorageUploader } from "./user_data_to_storage_uploader";

export class ExportUserDataGateway {

    constructor() { ; }

    private getExportUserDataRequestsCollection() {
        return SchulplanerReferences.firestoreReference.collection('ExportUserDataRequests');
    }

    private getExportUserDataRequestDocument(requestId: string) {
        return this.getExportUserDataRequestsCollection().doc(requestId);
    }

    async hasUserRequestedInTheLastSevenDays(userId: UserId): Promise<boolean> {
        const snapshot = await this.getExportUserDataRequestsCollection()
            .where('userId', '==', userId.uid)
            .where('requestTime', '>=', admin.firestore.Timestamp.fromMillis(admin.firestore.Timestamp.now().toMillis() - (7 * 24 * 3600000)))
            .where('status', 'in', ['successful', 'loading'])
            .get();
        if (snapshot.docs.length > 1) return true;
        else return false;
    }

    async updateExportUserRequestDataWithDownloadData(requestId: string, downloadUrl: string, totalBytes: number, expiresOn: admin.firestore.Timestamp) {
        await this.getExportUserDataRequestDocument(requestId).set({
            'downloadUrl': downloadUrl,
            'totalBytes': totalBytes,
            'status': 'successful',
            'expiresOn': expiresOn,
        }, { merge: true, });
    }

    async updateExportUserRequestDataWithError(requestId: string, errorMessage: string) {
        await this.getExportUserDataRequestDocument(requestId).set({
            'error': errorMessage,
            'status': 'error',
        }, { merge: true, });
    }


    async createExportUserData(userId: UserId): Promise<RequestMetaData | null> {
        const workbookBuilder = new BuildUserDataWorkbook({
            userDataGateway: new UserDataGateway()
        });
        const fileArchiver = new FileArchiver();
        const userDataToStorageUploader = new UserDataToStorageUploader({
            firebaseStorage: admin.storage(),
        });
        const files: ArchiveableFile[] = await workbookBuilder.buildUserDataWorkbook(userId);
        const archive = await fileArchiver.archiveFiles(files, 'Schulplaner Exportdaten');
        return userDataToStorageUploader.upload(userId.uid, archive);
    }



}