import * as AdmZip from 'adm-zip';
import * as exceljs from 'exceljs';
export abstract class ArchiveableFile {
    constructor(public fileName: string,
        public fileData: string | number | Buffer) { ; }

    public abstract getDataLength(): number;
}

export class TextArchiveableFile extends ArchiveableFile {

    constructor(public fileName: string, public fileData: string) {
        super(fileName, fileData);
    }

    public getDataLength(): number {
        return this.fileData.length;
    }
}

export class BufferArchiveableFile extends ArchiveableFile {
    constructor(fileName: string, public excelBuffer: exceljs.Buffer) {
        super(fileName, excelBuffer as Buffer);
    }

    public getDataLength(): number {
        return this.excelBuffer.byteLength;
    }
}


export class FileArchiver {

    constructor() { ; }

    async archiveFiles(files: ArchiveableFile[], archiveName: string): Promise<Buffer> {
        const zip = new AdmZip();
        for (const file of files) {
            zip.addFile(file.fileName, Buffer.alloc(file.getDataLength(), file.fileData));
        }
        return zip.toBuffer();
    }
}