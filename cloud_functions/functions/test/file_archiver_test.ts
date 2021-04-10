// tslint:disable-next-line:no-implicit-dependencies
import { expect } from "chai";
// tslint:disable-next-line:no-implicit-dependencies
import { it, describe } from "mocha";
import { BufferArchiveableFile, FileArchiver, TextArchiveableFile } from '../src/export_user_data/logic/file_archiver';
import * as exceljs from 'exceljs';

describe("General Archiver Test", () => {

    it("builds Archive of GeneralData", async () => {

        const fileArchiver = new FileArchiver();

        const archive = await fileArchiver.archiveFiles([
            new TextArchiveableFile('lala.txt', 'Hier steht was drin'),
            new BufferArchiveableFile('lala.xlsx', await (new exceljs.Workbook().xlsx.writeBuffer())),
        ], 'Schulplaner Exportdaten');
        expect(archive.length > 0).equals(true);
    });


});