// tslint:disable-next-line:no-implicit-dependencies
import { expect } from "chai";
// tslint:disable-next-line:no-implicit-dependencies
import { it, describe } from "mocha";
import { FileArchiver } from '../src/export_user_data/logic/file_archiver';
import { BuildUserDataWorkbook } from '../src/export_user_data/logic/build_user_data_workbook';

describe("General Archiver Test", () => {

    it("builds UserData Workbook", async () => {
        const workbookBuilder = new BuildUserDataWorkbook();
        const fileArchiver = new FileArchiver();
        const workbookBuffer: any = await workbookBuilder.buildUserDataWorkbook();
        const archive = await fileArchiver.archiveFiles(workbookBuffer, 'Schulplaner Exportdaten');
        expect(archive.length > 0).equals(true);
    });


});