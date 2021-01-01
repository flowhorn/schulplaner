
export function isTaskFinished(memberid: string, task: any): boolean {
    if (task.finished != null) {
        if (task.finished[memberid] != null) {
            if (task.finished[memberid].finished === true) {
                return true;
            } else return false;
        }
        else return false;
    } else return false;
}
