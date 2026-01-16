import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/inquiry_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/db_service.dart';
import 'inquiry_write_screen.dart';
import 'inquiry_detail_screen.dart';
import '../../features/home/drawer_menu.dart';


class InquiryListScreen extends StatelessWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      appBar: const CustomAppBar(title: '문의사항'),
      endDrawer: const DrawerMenu(),
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.success, // 문의는 초록색 포인트
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InquiryWriteScreen()));
        },
      ),
      body: StreamBuilder<List<InquiryModel>>(
        stream: DbService().getMyInquiries(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("등록된 문의가 없습니다.", style: TextStyle(color: AppColors.textGrey)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                onTap: () {
                  // 상세 화면으로 이동
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryDetailScreen(inquiry: item)));
                },
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(16),
                title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(DateFormat('yyyy.MM.dd').format(item.createdAt), style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isReplied ? AppColors.primary.withOpacity(0.1) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.isReplied ? "답변완료" : "대기중",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: item.isReplied ? AppColors.primary : AppColors.textGrey
                    ),
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