import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class PdfGenerator {
  static Future<void> generateAndDownloadPdf(List<QueryDocumentSnapshot> cutoffData) async {
    final pdf = pw.Document();

    // Create PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Cutoff Times Report', 
                style: pw.TextStyle(
                  fontSize: 24, 
                  fontWeight: pw.FontWeight.bold
                )
              )
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Date', 'Email', 'Cutoff Time', 'Turn On Time', 'Fuel Level'],
              data: cutoffData.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return [
                  '${data['cutoffDate'] ?? 'N/A'}',
                  '${data['email'] ?? 'N/A'}',
                  '${data['cutoffTime'] ?? 'N/A'}',
                  '${data['turnOnTime'] ?? 'N/A'}',
                  '${data['fuelLevel']?.toString() ?? 'N/A'}',
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
              },
            ),
          ];
        },
      ),
    );

    // Get the application directory
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/cutoff_report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    // Save the PDF
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFile.open(path);
  }
}