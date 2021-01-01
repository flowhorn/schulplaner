import { MemberId } from "../../user/models/member_id";
import { MapData } from "../../utils/map_converter";
import { MemberRole, MemberRoleConverter } from "./member_role";
import * as admin from 'firebase-admin';

export class MemberData {
    public memberId: MemberId;
    public role: MemberRole;
    public joinedOn: admin.firestore.Timestamp;
    public name: string;


    constructor(params: {
        memberId: MemberId,
        role: MemberRole,
        joinedOn: admin.firestore.Timestamp,
        name: string,
    }) {
        this.memberId = params.memberId;
        this.role = params.role;
        this.joinedOn = params.joinedOn;
    }

    static fromData(data: MapData<any>): MemberData {
        return new MemberData({
            memberId: MemberId.fromMemberString(data['id']),
            role: MemberRoleConverter.fromData(data['role']),
            // Wenn keine aktuelle Zeit vorliegt, wird der aktuelle Zeitpunkt gewählt.
            joinedOn: data['joinedOn'] || admin.firestore.Timestamp.fromMillis(1600596541081),
            name: data['name'],
        });
    }


    toData(): MapData<any> {
        return {
            'id': this.memberId.toString(),
            'role': MemberRoleConverter.toData(this.role),
            'joinedOn': this.joinedOn,
            'name': this.name || null,
        };
    };
}