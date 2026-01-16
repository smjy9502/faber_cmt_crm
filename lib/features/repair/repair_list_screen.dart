import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅용
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/repair_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/db_service.dart';
import 'repair_form_screen.dart';
import '../../features/home/drawer_menu.dart';


class RepairListScreen extends StatelessWidget {
  const RepairListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      appBar: const CustomAppBar(title: '내 A/S 접수 현황'),
      endDrawer: const DrawerMenu(),
      backgroundColor: AppColors.background,

      // 글쓰기 버튼 (우측 하단 + 버튼)
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RepairFormScreen()),
          );
        },
      ),

      body: StreamBuilder<List<RepairModel>>(
        // 내 ID로 된 데이터만 실시간 감시
        stream: DbService().getMyRepairs(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("데이터 로드 오류: ${snapshot.error}"));
          }

          final repairs = snapshot.data ?? [];

          if (repairs.isEmpty) {
            return const Center(
              child: Text("접수된 내역이 없습니다.\n+ 버튼을 눌러 접수해주세요.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: repairs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = repairs[index];
              return _buildRepairCard(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildRepairCard(RepairModel item) {
    // 상태에 따른 색상 구분
    Color statusColor;
    if (item.status == '완료') {
      statusColor = AppColors.success;
    } else if (item.status == '처리중') {
      statusColor = AppColors.accent;
    } else {
      statusColor = AppColors.textGrey; // 접수대기
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상태 뱃지
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              // 날짜
              Text(
                DateFormat('yyyy.MM.dd').format(item.createdAt),
                style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}