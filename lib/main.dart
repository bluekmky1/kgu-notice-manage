import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'routes/app_router.dart';
import 'theme/notice_manager_color_theme.dart';
import 'theme/notice_manager_colors.dart';

void main() {
  // URL에서 # 제거
  setUrlStrategy(PathUrlStrategy());

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: ref.watch(appRouterProvider).router,
        title: '경영학전공 공지 요약 생성기',
        theme: ThemeData(
          extensions: const <ThemeExtension<dynamic>>[
            NoticeManagerColorTheme.light,
          ],
          fontFamily: 'Pretendard',
          appBarTheme: const AppBarTheme(
            backgroundColor: NoticeManagerColors.main,
            foregroundColor: NoticeManagerColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          scaffoldBackgroundColor: NoticeManagerColors.background,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: NoticeManagerColors.main,
            selectionColor: NoticeManagerColors.main.withAlpha(100),
            selectionHandleColor: NoticeManagerColors.main,
          ),
        ),
      );
}
