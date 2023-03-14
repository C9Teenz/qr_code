import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code/app/data/models/products_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxList<ProductsModel> allProduct = <ProductsModel>[].obs;

  void downloadCatalog() async {
    final pdf = pw.Document();
    //make page for view pdf file
    var result = await db.collection("products").get();
    allProduct.value =
        result.docs.map((e) => ProductsModel.fromJson(e.data())).toList();

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            List<pw.TableRow> allData = List.generate(
              allProduct.length,
              (index) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${index + 1}',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      allProduct[index].code,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      allProduct[index].name,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${allProduct[index].quantity}',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.BarcodeWidget(
                        color: PdfColors.black,
                        barcode: pw.Barcode.qrCode(),
                        data: allProduct[index].code,
                        width: 50,
                        height: 50),
                  ),
                ],
              ),
            );
            return [
              pw.Center(
                child: pw.Text(
                  "Catalog Product",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(width: 2, color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          'No',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          'Code Product',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          'Name Product',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          'Quantity',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          'Qr Code',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...allData
                ],
              ),
            ];
          }),
    );
    //save pdf to internal memory
    Uint8List bytes = await pdf.save();

    //make folder in device
    final dir = await getApplicationDocumentsDirectory();
    //make empty file
    final file = File('${dir.path}/MyDocument.pdf');

    //overwrite empty file with bytes
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getBarcode(String code) async {
    try {
      var result =
          await db.collection('products').where("code", isEqualTo: code).get();
      if (result.docs.first.data().isEmpty) {
        throw "error";
      } else {
        Map<String, dynamic> data = result.docs.first.data();
        return {
          "error": false,
          "message": "Successful getting data...",
          "data": ProductsModel.fromJson(data)
        };
      }
    } catch (e) {
      return {
        "error": true,
        "message": "Data not found",
      };
    }
  }
}
