import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // 텍스트 타이틀 (옵션)
  final Widget? titleWidget; // 이미지 타이틀 (옵션)
  final bool showCart;
  final VoidCallback? onCartPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget, // 추가됨
    this.showCart = false,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text( // 이미지가 있으면 이미지, 없으면 텍스트
        title ?? '',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
      ),
      actions: [
        if (showCart)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textBlack, size: 28),
              onPressed: onCartPressed ?? () {},
            ),
          ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textBlack, size: 30),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}