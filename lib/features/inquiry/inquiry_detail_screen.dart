import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/inquiry_model.dart';

class InquiryDetailScreen extends StatelessWidget {
  final InquiryModel inquiry;

  const InquiryDetailScreen({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '문의 상세'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 질문 영역
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Q. ${inquiry.title}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(DateFormat('yyyy.MM.dd HH:mm').format(inquiry.createdAt), style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  const Divider(height: 30),
                  Text(inquiry.content, style: const TextStyle(fontSize: 15, height: 1.5)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. 답변 영역 (답변이 있을 때만 표시)
            if (inquiry.isReplied && inquiry.adminReply != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05), // 살짝 파란 배경
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text("관리자 답변", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(inquiry.adminReply!, style: const TextStyle(fontSize: 15, height: 1.5)),
                  ],
                ),
              )
            else
            // 답변 대기 중 표시
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.hourglass_empty, color: AppColors.textGrey),
                    SizedBox(height: 8),
                    Text("관리자 답변을 기다리고 있습니다.", style: TextStyle(color: AppColors.textGrey)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}