import 'cart_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items; // 구매한 상품들
  final int totalPrice;
  final String status; // '주문완료', '배송중' 등
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt,
    };
  }
}