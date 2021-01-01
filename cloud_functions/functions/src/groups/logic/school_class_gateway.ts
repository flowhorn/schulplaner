import * as admin from "firebase-admin";
import { getMapItem } from "../../common";
import { SchulplanerReferences } from "../../schulplaner_globals";
import { UserGateway } from "../../user/gateway/user_gateway";
import { MemberId } from "../../user/models/member_id";
import { UserId } from "../../user/models/user_id";
import { GroupId } from "../models/group_id";
import { MemberData } from "../models/member_data";
import { MemberRole, MemberRoleConverter } from "../models/member_role";
import { SchoolClassData } from "../models/school_class_data";

export class SchoolClassGateway {

    constructor(private userGateway: UserGateway) { ; }

    async getSchoolClassData(courseId: GroupId): Promise<SchoolClassData | null> {
        const snapshot = await SchulplanerReferences.getCourseDocument(courseId).get();
        if (snapshot.exists) return SchoolClassData.fromData(snapshot.data());
        else return null;
    }


    async addSchoolClassFromConnectionsData(memberId: MemberId, schoolClassId: GroupId) {
        await SchulplanerReferences.getConnectionsDocument(memberId).set({
            'myclasses': getMapItem(schoolClassId.id, true),
        }, { merge: true, });
    }

    async removeSchoolClassFromConnectionsData(memberId: MemberId, schoolClassId: GroupId) {
        await SchulplanerReferences.getConnectionsDocument(memberId).set({
            'myclasses': getMapItem(schoolClassId.id, admin.firestore.FieldValue.delete()),
        }, { merge: true, });
    }

    async removeMemberDataFromSchoolClass(memberId: MemberId, schoolClassId: GroupId) {
        try {
            await SchulplanerReferences.getSchoolClassDocument(schoolClassId).set({
                'members': getMapItem(memberId.toString(), admin.firestore.FieldValue.delete()),
                'membersList': admin.firestore.FieldValue.arrayRemove(memberId.toString()),
                'membersData': getMapItem(memberId.toString(), admin.firestore.FieldValue.delete()),
                'userRoles': getMapItem(memberId.userId.uid, admin.firestore.FieldValue.delete()),
            }, { merge: true, });
        } catch (e) { console.log(e); }
    }

    async updateMemberRole(memberId: MemberId, schoolClassId: GroupId, newRole: MemberRole) {
        await SchulplanerReferences.getSchoolClassDocument(schoolClassId).set({
            'membersData': getMapItem(memberId.toString(), {
                'role': MemberRoleConverter.toData(newRole),
                'id': memberId.toString(),
            }),
            'userRoles': getMapItem(memberId.userId.uid, MemberRoleConverter.toData(newRole),
            ),
        }, { merge: true });
    }

    async addMemberDataFromSchoolClass(memberId: MemberId, schoolClassId: GroupId) {
        const userInfo = await this.userGateway.getUserInfo(memberId.userId);
        const newRole = MemberRole.standard;
        const memberData = new MemberData({
            memberId: memberId,
            role: newRole,
            joinedOn: admin.firestore.Timestamp.now(),
            name: userInfo.name,
        });
        try {
            await SchulplanerReferences.getSchoolClassDocument(schoolClassId).set({
                'membersList': admin.firestore.FieldValue.arrayRemove(memberId.toString()),
                'membersData': getMapItem(memberId.toString(), memberData.toData()),
                'userRoles': getMapItem(memberId.userId.uid, MemberRoleConverter.toData(newRole)),
            }, { merge: true });
        } catch (e) { console.log(e); }
    }

    async isMemberInSchoolClassV3(schoolClassId: GroupId, userId: UserId): Promise<boolean> {
        const snapshot = await SchulplanerReferences.getSchoolClassDocument(schoolClassId).get();
        if (!snapshot.exists) return false;
        const userRoles = snapshot.get('userRoles');
        if (userRoles == null) return false;
        return userRoles[userId.uid] != null;
    }

    async addConnectedCourseToClass(schoolClassId: GroupId, courseId: GroupId) {
        await SchulplanerReferences.getSchoolClassDocument(schoolClassId).set({
            courses: getMapItem(courseId.id, true),
        }, { merge: true });
    }

    async removeConnectedCourseToClass(schoolClassId: GroupId, courseId: GroupId) {
        await SchulplanerReferences.getSchoolClassDocument(schoolClassId).set({
            courses: getMapItem(courseId.id, admin.firestore.FieldValue.delete()),
        }, { merge: true });
    }

}