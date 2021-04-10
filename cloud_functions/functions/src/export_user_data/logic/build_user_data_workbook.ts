import * as exceljs from 'exceljs';
import { UserId } from '../../user/models/user_id';
import { ArchiveableFile, BufferArchiveableFile, TextArchiveableFile } from './file_archiver';
import { UserDataGateway } from './user_data_gateway';

export class BuildUserDataWorkbook {

    public userDataGateway: UserDataGateway;

    constructor(params: {
        userDataGateway: UserDataGateway,
    }) {
        this.userDataGateway = params.userDataGateway;
    }

    public async buildUserDataWorkbook(userId: UserId): Promise<ArchiveableFile[]> {
        const workbook = new exceljs.Workbook();
        this.createUserInfoWorksheet(workbook);


        const rawUserData = await this.userDataGateway.getRawData(userId);

        const files: ArchiveableFile[] = [
            new BufferArchiveableFile(
                'Allgemeine Informationen.xlsx',
                await workbook.xlsx.writeBuffer(),
            ),
            new TextArchiveableFile(
                'rawData.json',
                JSON.stringify(rawUserData),
            ),

        ];
        return files;
    };

    private createUserInfoWorksheet(workbook: exceljs.Workbook) {
        const sheet = workbook.addWorksheet('Userinformationen');

        sheet.addRow([
            'Aktuell in Entwicklung',
            'Die Exportfunktion findet sich aktuell in Entwicklung. Du kannst dir aber schon jetzt alle Rohdaten in rawData.json anschauen!',
        ]);
    }
}