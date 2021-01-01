import { SchulplanerReferences } from "../../schulplaner_globals";
import { UserData } from "../models/user";
import { UserId } from "../models/user_id";


export class UserGateway {

    async getUserInfo(userId: UserId): Promise<UserData> {
        const document = SchulplanerReferences.getUsersInfoDocument(userId);
        const documentData = await document.get();
        return UserData.fromData(userId, documentData.data());
    }
}