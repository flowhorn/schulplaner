import * as functions from 'firebase-functions';
import { europeRegion } from '../../schulplaner_globals';
import { ExportUserDataRequestHandler, ExportUserDataRequestHandlerParams } from '../handler/export_user_data_request_handler';
import { ExportUserDataGateway } from '../logic/export_user_data_gateway';
import { ExportUserDataRequest } from '../models/export_user_data_request';


export const exportUserDataRequestTriggerFunction = functions
    .runWith({
        memory: '2GB',
        timeoutSeconds: 540,
    }).region(europeRegion)
    .firestore
    .document('/ExportUserDataRequests/{requestId}')
    .onCreate(async (snapshot, context) => {
        const requestData = ExportUserDataRequest.fromData(snapshot.id, snapshot.data());
        const handler = new ExportUserDataRequestHandler({
            exportUserDataGateway: new ExportUserDataGateway(),
        });
        const params: ExportUserDataRequestHandlerParams = {
            exportUserDataRequest: requestData,
        };
        return await handler.handle(params);
    });