import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProductView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            controller: codeC,
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
                if (codeC.text.isNotEmpty &&
                    nameC.text.isNotEmpty &&
                    qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> result = await controller.addProduct({
                    'code': codeC.text,
                    'name': nameC.text,
                    'quantity': int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoading(false);
                  Get.back();
                  Get.snackbar(result['error'] == true ? 'Failed' : 'Success',
                      result['message']);
                } else {
                  Get.snackbar('Error', 'Tidak boleh ada yang kosong');
                }
              }
            },
            child: Obx(
              () => Text(
                  controller.isLoading.isFalse ? 'Add Product' : 'Loading...'),
            ),
          )
        ],
      ),
    );
  }
}
