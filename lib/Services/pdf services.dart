import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class PDFService {
  static Future<void> generatePDF(List<dynamic> data, BuildContext context) async {
    try {
      final pdf = pw.Document();
      
      // Set the maximum number of items per page
      const int itemsPerPage = 8;

      // Split data into pages
      for (var i = 0; i < data.length; i += itemsPerPage) {
        final pageData = data.skip(i).take(itemsPerPage).toList();
        
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Cutoff Report', 
                        style: pw.TextStyle(
                          fontSize: 24, 
                          fontWeight: pw.FontWeight.bold
                        )
                      ),
                      pw.Text(
                        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
                        style: pw.TextStyle(fontSize: 12)
                      ),
                    ]
                  ),
                  pw.SizedBox(height: 20),
                  
                  // Data entries
                  ...pageData.map((doc) {
                    final cutoffData = doc.data() as Map<String, dynamic>;
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 15),
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Email: ${cutoffData['email'] ?? 'N/A'}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Cutoff Time: ${cutoffData['cutoffTime'] ?? 'N/A'}'),
                                  pw.Text('Cutoff Date: ${cutoffData['cutoffDate'] ?? 'N/A'}'),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Turn On Time: ${cutoffData['turnOnTime'] ?? 'N/A'}'),
                                  pw.Text('Turn On Date: ${cutoffData['turnOnDate'] ?? 'N/A'}'),
                                ],
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text('Fuel Level: ${cutoffData['fuelLevel'] ?? '0.0'}'),
                        ],
                      ),
                    );
                  }).toList(),

                  // Page number placed inside a container at the bottom
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Page ${(i ~/ itemsPerPage) + 1} of ${(data.length / itemsPerPage).ceil()}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      // Save the PDF
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'Cutoff_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      
      // Save the file
      await file.writeAsBytes(await pdf.save());

      // Try to open the file
      await OpenFile.open(file.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: ${file.path}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error in PDF generation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }
}
