// lib/app.dart  — GoRouter navigation + shell route
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/services/ocr_service.dart';
import 'core/theme/app_theme.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/camera/screens/camera_screen.dart';
import 'features/camera/screens/preview_crop_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/history/screens/history_screen.dart';
import 'features/ocr_review/screens/ocr_review_screen.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/onboarding/screens/intro_slides_screen.dart';
import 'features/onboarding/screens/name_input_screen.dart';
import 'features/receipt_detail/screens/receipt_detail_screen.dart';
import 'features/reminder/screens/reminder_list_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'shared/widgets/app_bottom_nav.dart';

// ─── Router provider ──────────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final isOnboardingDone = ref.watch(isOnboardingDoneProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (ctx, state) {
      final onboarded = isOnboardingDone;
      final goingOnboarding = state.matchedLocation.startsWith('/onboarding');
      final isSplash = state.matchedLocation == '/splash';
      
      if (isSplash) return null;
      
      if (!onboarded && !goingOnboarding) return '/onboarding';
      if (onboarded && goingOnboarding) return '/home';
      return null;
    },
    routes: [
      // ─── Splash ──────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      // ─── Onboarding ──────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeIn).animate(animation),
              child: child,
            );
          },
          child: const IntroSlidesScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding/name',
        builder: (_, __) => const NameInputScreen(),
      ),

      // ─── Shell (with bottom nav) ──────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppBottomNav(
          currentLocation: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
              child: const HomeScreen(),
            ),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (_, state) => ReceiptDetailScreen(
                  receiptId:
                      int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/history',
            builder: (_, __) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (_, __) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/reminders',
            builder: (_, __) => const ReminderListScreen(),
          ),
        ],
      ),

      // ─── Camera flow (full-screen, no bottom nav) ─────────────────────
      GoRoute(
        path: '/camera',
        builder: (_, __) => const CameraScreen(),
      ),
      GoRoute(
        path: '/camera/preview',
        builder: (_, state) {
          final imageFile = state.extra as File;
          return PreviewCropScreen(imageFile: imageFile);
        },
      ),
      GoRoute(
        path: '/camera/review',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OcrReviewScreen(
            photoPath: extra['photoPath'] as String,
            ocrResult: extra['ocrResult'] as OcrResult,
          );
        },
      ),

      // ─── Search (full-screen overlay) ────────────────────────────────
      GoRoute(
        path: '/search',
        builder: (_, __) => const SearchScreen(),
      ),
    ],
  );
});

// ─── App root ────────────────────────────────────────────────────────────────
class StrukuApp extends ConsumerWidget {
  const StrukuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Strukku',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
