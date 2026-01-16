import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // 고유 ID 생성을 위해 필요 (없으면 1초 뒤 설명 참고)
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../models/repair_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/db_service.dart';

class RepairFormScreen extends StatefulWidget {
  const RepairFormScreen({super.key});

  @override
  State<RepairFormScreen> createState() => _RepairFormScreenState();
}

class _RepairFormScreenState extends State<RepairFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  void _submitRepair() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('내용을 모두 입력해주세요.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = context.read<AuthProvider>().user;
      if (user == null) return;

      // 새 문서 ID 생성 (uuid 패키지가 없다면 DateTime 등을 써도 됨)
      final newId = DateTime.now().millisecondsSinceEpoch.toString();

      final repair = RepairModel(
        id: newId,
        userId: user.uid,
        title: _titleController.text,
        description: _descController.text,
        status: '접수대기',
        createdAt: DateTime.now(),
      );

      // DB 저장
      await DbService().createRepair(repair);

      if (!mounted) return;
      Navigator.pop(context); // 목록 화면으로 복귀
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A/S 접수가 완료되었습니다.')));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('에러 발생: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'A/S 접수하기'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("고장 증상을 자세히 적어주세요.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 제목 입력
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목 (예: 전원이 안 켜져요)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // 내용 입력
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '상세 증상',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // 접수 버튼
            ElevatedButton(
              onPressed: _isLoading ? null : _submitRepair,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('접수하기', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}