import * as admin from "firebase-admin";
import { getMapItem } from "../../common";
import { SchulplanerReferences } from "../../schulplaner_globals";
import { UserGateway } from "../../user/gateway/user_gateway";
import { MemberId } from "../../user/models/member_id";
import { UserId } from "../../user/models/user_id";
import { CourseData } from "../models/course_data";
import { GroupId } from "../models/group_id";
import { MemberData } from "../models/member_data";
import { MemberRole, MemberRoleConverter } from "../models/member_role";

export class CourseGateway {

    constructor(private userGateway: UserGateway) { ; }

    async getCourseData(courseId: GroupId): Promise<CourseData | null> {
        const snapshot = await SchulplanerReferences.getCourseDocument(courseId).get();
        if (snapshot.exists) return CourseData.fromData(snapshot.data());
        else return null;
    }

    async addCourseFromConnectionsData(memberId: MemberId, courseId: GroupId) {
        await SchulplanerReferences.getConnectionsDocument(memberId).set({
            'mycourses': getMapItem(courseId.id, true),
        }, { merge: true, });
    }

    async removeCourseFromConnectionsData(memberId: MemberId, courseId: GroupId) {
        await SchulplanerReferences.getConnectionsDocument(memberId).set({
            'mycourses': getMapItem(courseId.id, admin.firestore.FieldValue.delete()),
        }, { merge: true, });
    }

    async isMemberInCourseV3(courseId: GroupId, userId: UserId): Promise<boolean> {
        const snapshot = await SchulplanerReferences.getCourseDocument(courseId).get();
        if (!snapshot.exists) return false;
        const userRoles = snapshot.get('userRoles');
        if (userRoles == null) return false;
        return userRoles[userId.uid] != null;
    }

    async addMemberDataFromCourse(memberId: MemberId, courseId: GroupId) {
        const userInfo = await this.userGateway.getUserInfo(memberId.userId);
        const newRole = MemberRole.standard;
        const memberData = new MemberData({
            memberId: memberId,
            role: newRole,
            joinedOn: admin.firestore.Timestamp.now(),
            name: userInfo.name,
        });
        try {
            await SchulplanerReferences.getCourseDocument(courseId).set({
                'membersList': admin.firestore.FieldValue.arrayUnion(memberId.toString()),
                'membersData': getMapItem(memberId.toString(), memberData.toData()),
                'userRoles': getMapItem(memberId.userId.uid, MemberRoleConverter.toData(newRole)),
            }, { merge: true });
        } catch (e) { console.log(e); }
    }

    async updateMemberRole(memberId: MemberId, courseId: GroupId, newRole: MemberRole) {
        await SchulplanerReferences.getCourseDocument(courseId).set({
            'membersData': getMapItem(memberId.toString(), {
                'role': MemberRoleConverter.toData(newRole),
                'id': memberId.toString(),
            }),
            'userRoles': getMapItem(memberId.userId.uid, MemberRoleConverter.toData(newRole),
            ),
        }, { merge: true });
    }

    async removeMemberDataFromCourse(memberId: MemberId, courseId: GroupId) {
        try {
            await SchulplanerReferences.getCourseDocument(courseId).set({
                'members': getMapItem(memberId.toString(), admin.firestore.FieldValue.delete()),
                'membersList': admin.firestore.FieldValue.arrayRemove(memberId.toString()),
                'membersData': getMapItem(memberId.toString(), admin.firestore.FieldValue.delete()),
                'userRoles': getMapItem(memberId.userId.uid, admin.firestore.FieldValue.delete()),
            }, { merge: true });
        } catch (e) { console.log(e); }
    }

    async addConnectedClassToCourse(schoolClassId: GroupId, courseId: GroupId, courseData: CourseData) {
        const getAvailableClassNumberString = courseData.getAvailableClassNumberString();
        const map = {};
        map['connectedclasses'] = getMapItem(schoolClassId.id, true);
        map[getAvailableClassNumberString] = schoolClassId.id;
        await SchulplanerReferences.getCourseDocument(courseId).set(map, { merge: true });
    }

    async removeConnectedClassToCourse(schoolClassId: GroupId, courseId: GroupId, courseData: CourseData) {
        const getConnectedNumberString = courseData.getConnectedNumberString(schoolClassId);
        const map = {};
        map['connectedclasses'] = getMapItem(schoolClassId.id, admin.firestore.FieldValue.delete());
        if (getConnectedNumberString != null) map[getConnectedNumberString] = admin.firestore.FieldValue.delete();
        await SchulplanerReferences.getCourseDocument(courseId).set(map, { merge: true });
    }
}