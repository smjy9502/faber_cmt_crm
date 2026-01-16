import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '공지사항'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(news.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.campaign, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(news.author, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  Text(DateFormat('yyyy.MM.dd').format(news.createdAt), style: const TextStyle(color: AppColors.textGrey)),
                ],
              ),
              const Divider(height: 40),
              Text(news.content, style: const TextStyle(fontSize: 16, height: 1.6, color: AppColors.textBlack)),
            ],
          ),
        ),
      ),
    );
  }
}