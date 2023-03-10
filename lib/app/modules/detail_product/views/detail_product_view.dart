import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/data/models/products_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);
  final ProductsModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = product.quantity.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            //fungsi row disini untuk mengatasi width yang masih mengikuti widht listview
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImage(data: product.code),
              ),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            controller: codeC,
            readOnly: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                labelText: 'Code'),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: nameC,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                labelText: 'Name'),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: qtyC,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                labelText: 'Quantity'),
          ),
          const SizedBox(
            height: 35,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9))),
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  if (nameC.text == product.name &&
                      int.parse(qtyC.text) == product.quantity) {
                    controller.isLoading(false);
                    Get.snackbar('Failed', "Data same like before");
                  } else {
                    Map<String, dynamic> result = await controller.editProduct({
                      "id": product.productId,
                      "name": nameC.text,
                      "quantity": int.tryParse(qtyC.text) ?? 0,
                    });
                    controller.isLoading(false);
                    Get.back();
                    Get.snackbar(result['error'] == true ? 'Error' : 'Success',
                        result['message']);
                  }
                } else {
                  Get.snackbar('Failed', 'Name and Quantity cannot be null');
                }
              }
            },
            child: Obx(
              () => Text(
                  controller.isLoading.isFalse ? 'Edit Product' : 'Loading...'),
            ),
          ),
          TextButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Delete Product',
                    middleText: "Are you sure want delete this product?",
                    actions: [
                      OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cencel'),
                      ),
                      Obx(() => ElevatedButton(
                          onPressed: () async {
                            if (controller.isLoadingDelete.isFalse) {
                              controller.isLoadingDelete(true);
                              Map<String, dynamic> result = await controller
                                  .deleteProduct(product.productId);

                              controller.isLoadingDelete(false);
                              Get.back();
                              Get.back();
                              Get.snackbar(
                                  result["error"] == true ? "Error" : "Succes",
                                  result["message"]);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: controller.isLoadingDelete.isFalse
                                ? const Text('Yes')
                                : const CircularProgressIndicator(),
                          )))
                    ]);
              },
              child: Text(
                'Delete Product',
                style: TextStyle(color: Colors.red.shade900),
              ))
        ],
      ),
    );
  }
}
