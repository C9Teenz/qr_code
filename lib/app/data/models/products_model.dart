class ProductsModel {
  ProductsModel({
    required this.code,
    required this.name,
    required this.product,
    required this.quantity,
  });

  final String code;
  final String name;
  final String product;
  final int quantity;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        product: json["product"] ?? "",
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "product": product,
        "quantity": quantity,
      };
}
