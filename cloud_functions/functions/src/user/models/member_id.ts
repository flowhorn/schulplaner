import { UserId } from "./user_id";

export class MemberId {

    public userId: UserId;
    public plannerId: string;
    constructor(params: {
        userId: UserId,
        plannerId: string,
    }) {
        this.userId = params.userId;
        this.plannerId = params.plannerId;
    }

    static fromMemberString(memberString: string): MemberId {
        const splitted = memberString.split('::');
        return new MemberId(
            {
                userId: new UserId(splitted[0]),
                plannerId: splitted[1],
            }
        );
    }

    toString(): string {
        return this.userId.uid + '::' + this.plannerId;
    }
}