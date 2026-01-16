import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/db_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _processOrder(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final user = context.read<AuthProvider>().user;

    if (cart.items.isEmpty) return;

    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final order = OrderModel(
        id: orderId,
        userId: user!.uid,
        items: cart.items,
        totalPrice: cart.totalPrice,
        status: '주문완료',
        createdAt: DateTime.now(),
      );

      await DbService().createOrder(order);
      cart.clearCart(); // 장바구니 비우기

      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("주문 완료"),
          content: const Text("주문이 성공적으로 접수되었습니다.\n(결제 모듈은 추후 연동)"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pop(context); // 장바구니 화면 닫기
              },
              child: const Text("확인"),
            )
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('주문 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final currencyFormat = NumberFormat("#,###", "ko_KR");

    return Scaffold(
      appBar: const CustomAppBar(title: '장바구니'),
      backgroundColor: AppColors.background,
      body: cart.items.isEmpty
          ? const Center(child: Text("장바구니가 비어있습니다.", style: TextStyle(color: AppColors.textGrey)))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag, color: AppColors.primary, size: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("${currencyFormat.format(item.price)}원", style: const TextStyle(color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => cart.removeSingleItem(item.productId),
                      ),
                      Text("${item.quantity}개", style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          // 임시로 ProductModel을 만들어서 추가 (실제론 DB에서 가져오는게 안전하지만 여기선 간소화)
                          // *주의: 원래는 해당 Product 정보를 다시 가져와야 하지만,
                          // 로직상 같은 ID면 수량만 늘리므로 아래와 같이 처리 가능
                          // (하지만 models/cart_provider.dart의 addItem 로직에 맞춰야 하므로
                          // 여기서는 수량만 늘리는 함수를 provider에 추가하는게 좋으나,
                          // 일단 UI에서는 표시만 하고 넘어갈게.)
                          context.read<CartProvider>().increaseQuantity(item.productId);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 하단 결제 바
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("총 결제금액", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${currencyFormat.format(cart.totalPrice)}원", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _processOrder(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('주문하기', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}