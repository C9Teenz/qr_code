import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingDelete = false.obs;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> editProduct(Map<String, dynamic> data) async {
    try {
      await db.collection("products").doc(data["id"]).update({
        "name": data["name"],
        "quantity": data["quantity"],
      });

      return {
        "error": false,
        "message": 'Products Success to be Updated',
      };
    } catch (e) {
      return {
        "error": true,
        "message": 'Products failed to be updated',
      };
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      await db.collection("products").doc(id).delete();

      return {
        "error": false,
        "message": 'Products has been deleted',
      };
    } catch (e) {
      return {
        "error": true,
        "message": 'Products failed to be deleted',
      };
    }
  }
}
