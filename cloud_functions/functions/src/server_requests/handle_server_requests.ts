import * as functions from 'firebase-functions';
import { SchulplanerReferences } from '../schulplaner_globals';
import { MapData } from '../utils/map_converter';
import { ServerRequestTypes } from './add_server_request';
import { removeNotificationReminder } from './remove_notification_reminder';
import { removeServerRequest } from './remove_server_request';

export const handleServerRequestsFunction = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
    const serverRequests = await SchulplanerReferences.serverRequests.limit(300).get();
    console.log('Handle '+serverRequests.docs.length.toString()+' Server Requests');
    const handledUsers: MapData<boolean> = {};
    for(const serverRequest of serverRequests.docs){
        const data = serverRequest.data();
        const requestType = data['type'];
        const requestData = data['data'];
        if(requestType == ServerRequestTypes.REMOVE_NOTIFICATION_REMINDER){
            const memberId = requestData['id'];
            if(handledUsers[memberId] == true){
                // ALREADY HANDLED THIS USER!
                await removeServerRequest(serverRequest.id);
                await removeNotificationReminder(memberId);
            }else{
                await removeServerRequest(serverRequest.id);
                await removeNotificationReminder(memberId);
                handledUsers[memberId] = true;
            }
        }else{
            // OTHER REQUEST_TYPES ARE NOT SUPPORTED RIGHT NOW!
        }
    }
});