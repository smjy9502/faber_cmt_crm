import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../features/home/drawer_menu.dart';
import '../../models/product_model.dart';
import '../../services/db_service.dart';
import '../../providers/auth_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final currencyFormat = NumberFormat("#,###", "ko_KR");

    return Scaffold(
      // 장바구니 아이콘 표시 옵션 켬 (showCart: true)
      appBar: CustomAppBar(
        title: '소모품 구매',
        showCart: true,
        onCartPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
      ),
      endDrawer: const DrawerMenu(),
      backgroundColor: AppColors.background,

      // (개발용) 관리자만 보이는 '상품 데이터 생성' 버튼
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
        onPressed: () async {
          await DbService().addDummyProducts();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('더미 상품이 생성되었습니다!')));
        },
        label: const Text("상품생성(Admin)"),
        icon: const Icon(Icons.add_box),
      )
          : null,

      body: StreamBuilder<List<ProductModel>>(
        stream: DbService().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final products = snapshot.data ?? [];
          if (products.isEmpty) return const Center(child: Text("판매 중인 상품이 없습니다."));

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // 세로로 긴 카드
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 이미지 영역 (임시 아이콘)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Icon(Icons.inventory_2, size: 50, color: Colors.grey[400]),
                        ),
                      ),
                      // 정보 영역
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("${currencyFormat.format(product.price)}원", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}