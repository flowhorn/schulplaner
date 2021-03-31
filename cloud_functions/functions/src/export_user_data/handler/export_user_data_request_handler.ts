import { ExportUserDataGateway } from "../logic/export_user_data_gateway";
import { ExportUserDataRequest } from "../models/export_user_data_request";
import { RequestMetaData } from "../models/request_meta_data";

export interface ExportUserDataRequestHandlerParams {
    exportUserDataRequest: ExportUserDataRequest,
}

export class ExportUserDataRequestHandler {

    public exportUserDataGateway: ExportUserDataGateway;
    constructor(params: { exportUserDataGateway: ExportUserDataGateway }) {
        this.exportUserDataGateway = params.exportUserDataGateway;
    }

    async handle(params: ExportUserDataRequestHandlerParams): Promise<boolean> {
        if (await this.exportUserDataGateway.hasUserRequestedInTheLastSevenDays(params.exportUserDataRequest.userId)) {
            await this.exportUserDataGateway.updateExportUserRequestDataWithError(params.exportUserDataRequest.id, 'Too many requests in the last seven days!');
            return false;
        }


        //Create RequestMetaData 
        const requestMetaData: RequestMetaData | null = await this.exportUserDataGateway.createExportUserData(params.exportUserDataRequest.userId);
        if (requestMetaData == null) {
            await this.exportUserDataGateway.updateExportUserRequestDataWithError(params.exportUserDataRequest.id, 'Internal Error!');
            return false;
        } else {
            await this.exportUserDataGateway.updateExportUserRequestDataWithDownloadData(params.exportUserDataRequest.id, requestMetaData.downloadUrl, requestMetaData.totalBytes, requestMetaData.expiresOn);
            return true;
        }
    }
}