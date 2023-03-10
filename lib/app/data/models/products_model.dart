class ProductsModel {
  ProductsModel({
    required this.code,
    required this.name,
    required this.productId,
    required this.quantity,
  });

  final String code;
  final String name;
  final String productId;
  final int quantity;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        productId: json["productId"] ?? "",
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productId": productId,
        "quantity": quantity,
      };
}
