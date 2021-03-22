import { firestore } from 'firebase-admin';
import { UserId } from '../../user/models/user_id';
import { MapData } from '../../utils/map_converter';

export class ExportUserDataRequest {
    public id: string;
    public userId: UserId;
    public requestTime: firestore.Timestamp;
    public status: 'loading' | 'successful' | 'error';
    public downloadUrl: string | null;
    public totalBytes: number | null;
    public error: boolean | null;

    constructor(params: {
        id: string,
        userId: UserId,
        requestTime: firestore.Timestamp,
        downloadUrl: string | null,
        totalBytes: number | null,
        error: boolean | null,
        status: 'loading' | 'successful' | 'error',
    }) {
        this.id = params.id;
        this.userId = params.userId;
        this.requestTime = params.requestTime;
        this.downloadUrl = params.downloadUrl;
        this.totalBytes = params.totalBytes;
        this.error = params.error;
        this.status = params.status;
    }

    static fromData(id: string, data: MapData<any>): ExportUserDataRequest {
        return new ExportUserDataRequest({
            id: id,
            userId: new UserId(data['userId']),
            requestTime: data['requestTime'],
            downloadUrl: data['downloadUrl'],
            totalBytes: data['totalBytes'],
            error: data['error'],
            status: data['status'],
        });
    }
}