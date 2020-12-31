import { MapData } from "../../utils/map_converter";
import { UserId } from "./user_id";

export class UserData {
    public id: UserId;
    public name: string;

    constructor(params: {
        id: UserId,
        name: string,
    }) {
        this.id = params.id;
        this.name = params.name;
    }

    static fromData(userId: UserId, data: MapData<any>): UserData {
        return new UserData(
            {
                id: userId,
                name: data != null ? data['name'] : null,
            }
        );
    }
}