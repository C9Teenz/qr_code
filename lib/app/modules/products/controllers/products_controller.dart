import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  FirebaseFirestore product = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getProduct() async* {
    yield* product.collection('products').snapshots();
  }
}
