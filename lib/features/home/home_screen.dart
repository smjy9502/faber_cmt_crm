// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../providers/auth_provider.dart';
import '../../services/db_service.dart';
import '../../models/repair_model.dart';
import '../../models/inquiry_model.dart';
import 'drawer_menu.dart';
// 화면 import
import '../repair/repair_list_screen.dart';
import '../inquiry/inquiry_list_screen.dart';
import '../news/news_list_screen.dart';
import '../shop/product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 진행률 계산을 위해 유저 ID가 필요함
    final user = context.watch<AuthProvider>().user;
    final userId = user?.uid ?? '';

    return Scaffold(
      // AppBar에 로고 이미지 적용
      appBar: CustomAppBar(
        titleWidget: Image.asset(
          'assets/logo.png',
          height: 32, // 로고 크기 조절
          fit: BoxFit.contain,
        ),
      ),
      endDrawer: const DrawerMenu(),
      backgroundColor: AppColors.background,
      body: Center( // 화면 중앙 정렬
        child: Padding(
          padding: const EdgeInsets.all(24.0), // 전체 여백 넉넉하게
          child: GridView.count(
            shrinkWrap: true, // 내용물만큼만 크기 차지
            physics: const NeverScrollableScrollPhysics(), // 스크롤 방지 (고정 메뉴)
            crossAxisCount: 2,
            mainAxisSpacing: 20, // 카드 간격 넓힘
            crossAxisSpacing: 20,
            childAspectRatio: 0.85, // 카드를 약간 세로로 길게 (정보 표시용)
            children: [
              // 1. A/S 접수 (좌측 상단) - 진행률 표시
              _buildProgressCard(
                context,
                title: 'A/S 접수',
                stream: DbService().getMyRepairs(userId),
                type: 'repair',
                icon: Icons.handyman_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RepairListScreen())),
              ),

              // 2. 문의사항 (우측 상단) - 진행률 표시
              _buildProgressCard(
                context,
                title: '문의사항',
                stream: DbService().getMyInquiries(userId),
                type: 'inquiry',
                icon: Icons.support_agent_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InquiryListScreen())),
              ),

              // 3. 소모품 구매 (좌측 하단) - 일반 아이콘
              _buildGridCard(
                context,
                title: '소모품 구매',
                icon: Icons.shopping_bag_outlined,
                color: Colors.orange.shade50,
                iconColor: AppColors.accent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen())),
              ),

              // 4. 공지사항 (우측 하단) - 일반 아이콘
              _buildGridCard(
                context,
                title: '공지사항',
                icon: Icons.campaign_outlined,
                color: Colors.purple.shade50,
                iconColor: Colors.purple,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [Type 1] 일반 메뉴 카드 (쇼핑, 공지사항용)
  Widget _buildGridCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Type 2] 진행률 표시 카드 (A/S, 문의사항용)
  Widget _buildProgressCard(
      BuildContext context, {
        required String title,
        required Stream<List<dynamic>> stream, // A/S나 문의 리스트 스트림
        required String type, // 'repair' or 'inquiry'
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: StreamBuilder<List<dynamic>>(
          stream: stream,
          builder: (context, snapshot) {
            double percent = 0.0;
            int total = 0;
            int completed = 0;

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final list = snapshot.data!;
              total = list.length;

              if (type == 'repair') {
                // A/S: status가 '완료'인 것
                completed = list.where((item) => (item as RepairModel).status == '완료').length;
              } else {
                // 문의: isReplied가 true인 것
                completed = list.where((item) => (item as InquiryModel).isReplied).length;
              }

              if (total > 0) percent = completed / total;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 원형 그래프 영역
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: total == 0 ? 0 : percent, // 0~1 사이 값
                        strokeWidth: 6,
                        backgroundColor: AppColors.background,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            percent == 1.0 ? AppColors.success : AppColors.primary
                        ),
                        strokeCap: StrokeCap.round, // 끝부분 둥글게
                      ),
                    ),
                    // 가운데 아이콘
                    Icon(icon, size: 28, color: total == 0 ? AppColors.textGrey : AppColors.textBlack),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textBlack),
                ),
                const SizedBox(height: 4),
                // 진행 상황 텍스트 (예: 1/3 완료)
                Text(
                  total == 0 ? "접수 내역 없음" : "$completed건 완료 / 총 $total건",
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}