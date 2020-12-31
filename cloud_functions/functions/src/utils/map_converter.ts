
export type MapData<T> = { [key: string]: T };

export function decodeMap<T>(data: MapData<any>, objectBuilder: (objectData: any) => T) {
    const newMap: MapData<T> = {};
    if (data == null) return newMap;
    for (const key of Object.keys(data)) {
        newMap[key] = objectBuilder(data[key]);
    }
    return newMap;
}

export function decodeList<T>(data: any, objectBuilder: (objectData: any) => T) {
    const newList: T[] = [];
    if (data == null) return newList;
    for (const key of Array.of(data)) {
        newList.push(objectBuilder(key));
    }
    return newList;
}

export function encodeList<T>(data: T[], objectBuilder: (objectData: T) => any) {
    const newList: any[] = [];
    for (const key of data) {
        newList.push(objectBuilder(key));
    }
    return newList;
}

export function encodeMap<T>(encodedMap: MapData<T>, objectEncoder: (objectData: T) => any) {
    return mapMap<T, any>(encodedMap, objectEncoder);
}

export function mapMap<T1, T2>(map1: MapData<T1>, objectEncoder: (objectData: T1) => T2) {
    const newMap: MapData<T2> = {};
    for (const key of Object.keys(map1)) {
        const entry = map1[key];
        newMap[key] = objectEncoder(entry);
    }
    return newMap;
}