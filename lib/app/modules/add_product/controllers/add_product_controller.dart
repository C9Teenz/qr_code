import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      var result = await db.collection('products').add(data);
      await db.collection('products').doc(result.id).update({
        'productId': result.id,
      });

      return {
        "error": false,
        "message": 'Products Success to be added',
      };
    } catch (e) {
      return {
        "error": true,
        "message": 'Products failed to be added',
      };
    }
  }
}
