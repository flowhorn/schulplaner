import * as AdmZip from 'adm-zip';

export class FileArchiver {

    constructor() { ; }

    async archiveFiles(firstFile: Buffer, archiveName: string): Promise<Buffer> {
        const zip = new AdmZip();
        for (const file of [firstFile]) {
            zip.addFile('Allgemeine Informationen.xlsx', Buffer.alloc(file.length, file));
        }
        return zip.toBuffer();
    }
}