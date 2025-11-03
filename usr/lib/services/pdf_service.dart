import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class PdfService {
  Future<void> generateAndSharePdf(Roster roster) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Duty Roster - ${roster.date.toString().split(' ')[0]}',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildShiftSection(roster.morningShift),
              pw.SizedBox(height: 20),
              _buildShiftSection(roster.afternoonShift),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/roster_${roster.date.toString().split(' ')[0]}.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'Duty Roster');
  }

  pw.Widget _buildShiftSection(Shift shift) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('${shift.icon} ${shift.name} Shift (${shift.timing})',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        if (shift.remarks.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text('Remarks: ${shift.remarks}'),
        ],
        pw.SizedBox(height: 12),
        pw.Text('North Ops Room:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ...shift.northOps.map((a) => pw.Text('• ${a.employee.rank} ${a.employee.name} ${a.remarks.isNotEmpty ? "(${a.remarks})" : ""}')).toList(),
        pw.SizedBox(height: 8),
        pw.Text('South Ops Room:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ...shift.southOps.map((a) => pw.Text('• ${a.employee.rank} ${a.employee.name} ${a.remarks.isNotEmpty ? "(${a.remarks})" : ""}')).toList(),
      ],
    );
  }
}