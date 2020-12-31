
export function notFinishedTasks(memberid: string, tasks: Array<any>): Array<any> {
    if (tasks == null) return [];
    const list = [];
    for (const entry of tasks) {
        if (entry.finished != null) {
            if (entry.finished[memberid] != null) {
                if (entry.finished[memberid].finished === true) {
                    break;
                } else list.push(entry);
            }
            else list.push(entry);
        } else list.push(entry);
    }
    return list;
}
