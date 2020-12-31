
export enum GroupType {
    course, schoolClass
}

const _courseString = 'course';
const _schoolClassString = 'schoolClass';

export class GroupTypeConverter {

    static fromData(data: string): GroupType {
        if (data === _courseString) {
            return GroupType.course;
        }
        if (data === _schoolClassString) {
            return GroupType.schoolClass;
        }
        throw Error();
    }

    static toData(groupType: GroupType): string {
        switch (groupType) {
            case GroupType.course:
                return _courseString;
            case GroupType.schoolClass:
                return _schoolClassString;
        }
        throw Error();
    }
}