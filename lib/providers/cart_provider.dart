import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  // 장바구니 총 금액 계산
  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  // 상품 담기
  void addItem(ProductModel product) {
    // 이미 담긴 상품인지 확인
    final index = _items.indexWhere((item) => item.productId == product.id);
    if (index >= 0) {
      _items[index].quantity += 1; // 이미 있으면 수량만 증가
    } else {
      _items.add(CartItemModel(
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: 1,
      ));
    }
    notifyListeners(); // 화면 갱신 알림
  }

  // 수량 증가 함수
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  // 수량 감소 (1개 미만이면 삭제)
  void removeSingleItem(String productId) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // 아예 삭제
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}