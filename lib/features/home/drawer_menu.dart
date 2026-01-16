import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 유저 정보 가져오기
    final auth = context.watch<AuthProvider>();
    final userEmail = auth.user?.email ?? '손님';

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. 상단 프로필 영역
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: Text(
              auth.isAdmin ? "관리자 모드" : "환영합니다!",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userEmail[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, color: AppColors.primary),
              ),
            ),
          ),

          // 2. 메뉴 리스트
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('홈으로'),
            onTap: () {
              // [수정 전] Navigator.pop(context); // 단순히 메뉴만 닫힘

              // [수정 후]
              Navigator.pop(context); // 1. 일단 드로어 메뉴를 닫고
              Navigator.popUntil(context, (route) => route.isFirst); // 2. 첫 화면(Home)이 나올 때까지 쌓인 화면들을 다 없앰
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('내 정보 (준비중)'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),

          // 3. 로그아웃 버튼
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('로그아웃', style: TextStyle(color: AppColors.error)),
            onTap: () {
              // 로그아웃 함수 호출 -> main.dart에서 감지하여 로그인 화면으로 자동 이동됨
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }
}