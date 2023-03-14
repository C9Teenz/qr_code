import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
        itemCount: 4,
        itemBuilder: (context, index) {
          late String name;
          late IconData icon;
          late VoidCallback onTap;
          switch (index) {
            case 0:
              name = 'Add Product';
              icon = Icons.post_add;
              onTap = () => Get.toNamed(Routes.addProduct);
              break;
            case 1:
              name = 'Products';
              icon = Icons.list_alt;
              onTap = () => Get.toNamed(Routes.products);
              break;
            case 2:
              name = 'QR Code';
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                    "#000000", "Cencel", true, ScanMode.QR);
                Map<String, dynamic> result =
                    await controller.getBarcode(barcode);
                if (result["error"] == true) {
                  Get.snackbar("Error", result["message"]);
                } else {
                  Get.toNamed(Routes.detailProduct, arguments: result['data']);
                }
              };
              break;
            case 3:
              name = 'Catalogs';
              icon = Icons.document_scanner;
              onTap = () => controller.downloadCatalog();
              break;
          }
          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 50,
                    ),
                    Text(name)
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> result = await authC.logout();
          if (result['error'] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar('Error', result['message']);
          }
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
