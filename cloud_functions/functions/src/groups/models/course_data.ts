import { MapData } from "../../utils/map_converter";
import { GroupId } from "./group_id";


export class CourseData {
    public id: GroupId;
    public name: string;
    public class1: GroupId | null;
    public class2: GroupId | null;
    public class3: GroupId | null;

    constructor(params: {
        id: GroupId,
        name: string,
        class1: string | null,
        class2: string | null,
        class3: string | null,
    }) {
        this.id = params.id;
        this.name = params.name;
        if (params.class1 != null) this.class1 = new GroupId(params.class1);
        if (params.class2 != null) this.class2 = new GroupId(params.class2);
        if (params.class3 != null) this.class3 = new GroupId(params.class3);
    }

    static fromData(data: MapData<any>): CourseData {
        return new CourseData({
            id: new GroupId(data['id']),
            name: data['name'],
            class1: data['class1'],
            class2: data['class2'],
            class3: data['class3'],
        });
    }

    sizeOfConnectedClasses() {
        var totals = 0;
        if (this.class1 != null) totals++;
        if (this.class2 != null) totals++;
        if (this.class3 != null) totals++;
        return totals;
    }

    toData(): MapData<any> {
        return {
            'id': this.id.id,
            'name': this.name,
        };
    }

    getConnectedNumberString(schoolClassId: GroupId) {
        if (this.class1 != null && this.class1.id === schoolClassId.id) return 'class1';
        if (this.class2 != null && this.class2.id === schoolClassId.id) return 'class2';
        if (this.class3 != null && this.class3.id === schoolClassId.id) return 'class3';
        return null;
    }

    getAvailableClassNumberString() {
        if (this.class1 == null) return 'class1';
        if (this.class2 == null) return 'class2';
        if (this.class3 == null) return 'class3';
        return null;
    }
}