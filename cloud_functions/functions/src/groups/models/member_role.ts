
export enum MemberRole {
    owner, admin, creator, standard, custom, none,
}

const _ownerString = 'owner';
const _adminString = 'admin';
const _creatorString = 'creator';
const _standardString = 'standard';
const _customString = 'custom';
const _noneString = 'none';

export class MemberRoleConverter {

    static fromData(data: string): MemberRole {
        if (data === _ownerString) {
            return MemberRole.owner;
        }
        if (data === _adminString) {
            return MemberRole.admin;
        }
        if (data === _creatorString) {
            return MemberRole.creator;
        }
        if (data === _standardString) {
            return MemberRole.standard;
        }
        if (data === _customString) {
            return MemberRole.owner;
        }
        if (data === _noneString) {
            return MemberRole.none;
        }
        throw Error();
    }

    static fromMemberType(memberType: number): MemberRole {
        if (memberType === 0) {
            return MemberRole.admin;
        } else if (memberType === 1) {
            return MemberRole.standard;
        }
        return MemberRole.standard;
    }

    static toData(memberRole: MemberRole): string {
        switch (memberRole) {
            case MemberRole.owner:
                return _ownerString;
            case MemberRole.admin:
                return _adminString;
            case MemberRole.creator:
                return _creatorString;
            case MemberRole.standard:
                return _standardString;
            case MemberRole.custom:
                return _customString;
            case MemberRole.none:
                return _noneString;
        }
        throw Error();
    }
}