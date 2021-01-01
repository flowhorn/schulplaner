import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class Printer {
  Future<void> sharePDF(Document pdf) async {
    await Printing.sharePdf(bytes: pdf.save(), filename: 'timetable.pdf');
  }

  Future<void> printPDF(Document pdf) async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
