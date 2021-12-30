import { SchulplanerReferences } from "../schulplaner_globals";
import { MapData } from "../utils/map_converter";


export class ServerRequestTypes {
    static REMOVE_NOTIFICATION_REMINDER = 'REMOVE_NOTIFICATION_REMINDER';
}

export async function addServerRequest(type: string, data: MapData<any>) {
    await SchulplanerReferences.serverRequests.doc().create({
        'type': type,
        'data': data,
    });
    console.log('created Server Request of type ' + type);
}