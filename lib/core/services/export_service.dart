// lib/core/services/export_service.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../core/models/receipt_model.dart';

class ExportService {
  static final _currencyFmt =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  static final _dateFmt = DateFormat('dd MMM yyyy', 'id_ID');

  // ─── Export to PDF ─────────────────────────────────────────────────────────
  Future<File> exportToPdf(List<ReceiptModel> receipts) async {
    final pdf = pw.Document();
    final total =
        receipts.fold<double>(0, (sum, r) => sum + r.totalAmount);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => _buildPdfHeader(ctx, receipts.length, total),
        build: (ctx) => [
          pw.SizedBox(height: 16),
          pw.Table(
            border: pw.TableBorder.all(
                color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.teal),
                children: [
                  _pdfCell('Nama Toko', header: true),
                  _pdfCell('Tanggal', header: true),
                  _pdfCell('Kategori', header: true),
                  _pdfCell('Total', header: true),
                ],
              ),
              ...receipts.map((r) => pw.TableRow(
                    children: [
                      _pdfCell(r.storeName),
                      _pdfCell(_dateFmt.format(r.date)),
                      _pdfCell(r.category.label),
                      _pdfCell(_currencyFmt.format(r.totalAmount)),
                    ],
                  )),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total: ${_currencyFmt.format(total)}',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath = path.join(
        dir.path, 'strukku_export_${DateTime.now().millisecondsSinceEpoch}.pdf');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildPdfHeader(
      pw.Context ctx, int count, double total) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('STRUKKU | Laporan Struk Belanja',
            style: pw.TextStyle(
                fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
        pw.SizedBox(height: 4),
        pw.Text(
            '$count struk | Total ${_currencyFmt.format(total)} | Diekspor ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 1, color: PdfColors.teal),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _pdfCell(String text, {bool header = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: header ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }

  // ─── Export to Excel ───────────────────────────────────────────────────────
  Future<File> exportToExcel(List<ReceiptModel> receipts) async {
    final excel = Excel.createExcel();
    final sheet = excel['Struk Belanja'];

    // Headers
    final headers = ['No', 'Nama Toko', 'Tanggal', 'Kategori', 'Total (Rp)', 'Item'];
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(bold: true);
    }

    // Data rows
    for (int i = 0; i < receipts.length; i++) {
      final r = receipts[i];
      final row = i + 1;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = IntCellValue(row);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(r.storeName);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(_dateFmt.format(r.date));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(r.category.label);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = DoubleCellValue(r.totalAmount);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
          .value = TextCellValue(r.items.map((e) => e.name).join(', '));
    }

    // Auto-fit columns
    sheet.setColumnWidth(0, 5);
    sheet.setColumnWidth(1, 25);
    sheet.setColumnWidth(2, 15);
    sheet.setColumnWidth(3, 15);
    sheet.setColumnWidth(4, 18);
    sheet.setColumnWidth(5, 40);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = path.join(
        dir.path, 'strukku_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel file');
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  // ─── Share file using native share sheet ─────────────────────────────────
  Future<void> shareFile(File file, {String? subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject ?? 'Strukku — Ekspor Struk Belanja',
    );
  }
}
