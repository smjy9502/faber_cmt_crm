class CartItemModel {
  final String productId;
  final String productName;
  final int price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });

  // 총 가격 계산 (가격 * 수량)
  int get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }
}