import { MapData } from "../../utils/map_converter";
import { GroupId } from "./group_id";

export class SchoolClassData {
    public id: GroupId;
    public name: string;

    constructor(params: {
        id: GroupId,
        name: string,
    }) {
        this.id = params.id;
        this.name = params.name;
    }

    static fromData(data: MapData<any>): SchoolClassData {
        return new SchoolClassData({
            id: new GroupId(data['id']),
            name: data['name'],
        });
    }

    toData(): MapData<any> {
        return {
            'id': this.id.id,
            'name': this.name,
        };
    }
}