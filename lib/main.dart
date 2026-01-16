import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common/constants/app_colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("=========== 앱 화면 빌드 시작 ==========="); // <--- 이 줄 추가
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CMT App',

      // ★ 여기가 핵심! 글로벌 테마 설정
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,

        // 1. 기본 색상 체계
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
        ),

        // 2. 폰트 설정 (전체 적용)
        textTheme: GoogleFonts.notoSansKrTextTheme(
          Theme.of(context).textTheme,
        ),

        // 3. 앱바 스타일
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0, // 그림자 없애서 깔끔하게
          centerTitle: false, // 제목 왼쪽 정렬 (요즘 트렌드)
          iconTheme: IconThemeData(color: AppColors.textBlack),
          titleTextStyle: TextStyle(
              color: AppColors.textBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),

        // 4. 입력창(TextField) 스타일 (둥글고 깔끔하게)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // 기본 테두리 없음
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),

        // 5. 버튼(ElevatedButton) 스타일
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white, // 글자색
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // 로그인이 되어 있다면? -> HomeScreen
          if (auth.user != null) {
            return const HomeScreen();
          }
          // 로그인이 안 되어 있다면? -> LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}