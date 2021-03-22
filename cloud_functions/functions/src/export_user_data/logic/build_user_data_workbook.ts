import * as exceljs from 'exceljs';

export class BuildUserDataWorkbook {

    constructor() { ; }

    public buildUserDataWorkbook(): Promise<exceljs.Buffer> {
        const workbook = new exceljs.Workbook();
        this.createUserInfoWorksheet(workbook);

        return workbook.xlsx.writeBuffer();
    };

    private createUserInfoWorksheet(workbook: exceljs.Workbook) {
        const sheet = workbook.addWorksheet('Userinformationen');

        sheet.addRow([
            'Email:',
            'example@gmail.com',
        ]);
    }
}