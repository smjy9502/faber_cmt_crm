import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###", "ko_KR");

    return Scaffold(
      appBar: CustomAppBar(
        title: '상품 상세',
        showCart: true,
        onCartPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. 상품 이미지 (임시)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: const Icon(Icons.inventory_2, size: 100, color: Colors.grey),
            ),
          ),

          // 2. 상품 정보
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(fontSize: 16, color: AppColors.textGrey, height: 1.5)),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("가격", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("${currencyFormat.format(product.price)}원", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 24),

                // 장바구니 담기 버튼
                ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('장바구니에 담았습니다.'),
                        action: SnackBarAction(
                          label: '확인',
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('장바구니 담기', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}