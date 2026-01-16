import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/news_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/db_service.dart';
import 'news_write_screen.dart';
import 'news_detail_screen.dart';
import '../../features/home/drawer_menu.dart';


class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 관리자 여부 확인
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: const CustomAppBar(title: '공지사항'),
      endDrawer: const DrawerMenu(),
      backgroundColor: AppColors.background,

      // ★ 관리자만 글쓰기 버튼 보임
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.edit_note, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsWriteScreen()));
        },
      )
          : null,

      body: StreamBuilder<List<NewsModel>>(
        stream: DbService().getAllNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("등록된 공지사항이 없습니다.", style: TextStyle(color: AppColors.textGrey)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(news: item)));
                },
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const CircleAvatar(
                  backgroundColor: AppColors.background,
                  child: Icon(Icons.campaign, color: AppColors.primary),
                ),
                title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('yyyy.MM.dd').format(item.createdAt), style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textGrey),
              );
            },
          );
        },
      ),
    );
  }
}