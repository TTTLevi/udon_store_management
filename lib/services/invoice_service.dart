import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck/models/invoice.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveInvoice(Invoice invoice) async {
    try {
      await _firestore.collection('bills').doc(invoice.id).set({
        'id': invoice.id,
        'staffId': invoice.staffId,
        'staffName': invoice.staffName,
        'items': invoice.items
            .map((item) => {
                  'productId': item.product.id,
                  'name': item.product.name,
                  'price': item.product.price,
                  'quantity': item.quantity,
                  'total': item.totalPrice,
                })
            .toList(),
        'totalAmount': invoice.totalAmount,
        'timeStamp': invoice.timeStamp.toIso8601String(),
        'paymentMethod': invoice.paymentMethod,
      });
    } catch (e) {
      print('Error saving invoice: $e');
    }
  }

  Future<File> generateInvoicePDF(Invoice invoice) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Hóa đơn',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                font: ttf, // Áp dụng font
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Mã hóa đơn: ${invoice.id}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Nhân viên: ${invoice.staffName} (ID: ${invoice.staffId})',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Thời gian: ${invoice.timeStamp.toString()}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Phương thức thanh toán: ${invoice.paymentMethod}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),
            pw.Text(
              'Chi tiết đơn hàng:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Text('Tên món',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text('Số lượng',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text('Đơn giá',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text('Thành tiền',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                ]),
                ...invoice.items.map(
                  (item) => pw.TableRow(children: [
                    pw.Text(item.product.name, style: pw.TextStyle(font: ttf)),
                    pw.Text(item.quantity.toString(),
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(item.product.price.toStringAsFixed(0),
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(item.totalPrice.toStringAsFixed(0),
                        style: pw.TextStyle(font: ttf)),
                  ]),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Tổng tiền: ${invoice.totalAmount.toStringAsFixed(0)}',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
          ],
        ),
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/invoice_${invoice.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> openPDF(File file) async {
    await OpenFile.open(file.path);
  }
}
