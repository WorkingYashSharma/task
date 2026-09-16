import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task/app/page_transitions.dart';
import 'package:task/core/constants/app_routes.dart';
import 'package:task/features/auth/login_view.dart';
import 'package:task/features/auth/login_view_model.dart';
import 'package:task/features/auth/verify_otp_view.dart';
import 'package:task/features/auth/verify_otp_view_model.dart';
import 'package:task/features/home/home_view.dart';
import 'package:task/features/home/home_view_model.dart';
import 'package:task/features/onboarding/onboarding_view.dart';
import 'package:task/features/onboarding/onboarding_view_model.dart';
import 'package:task/features/splash/splash_view.dart';
import 'package:task/features/splash/splash_view_model.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) {
          return appFadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(
              create: (_) => SplashViewModel(),
              child: const SplashView(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) {
          return appFadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(
              create: (_) => OnboardingViewModel(),
              child: const OnboardingView(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) {
          return appFadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(
              create: (_) => LoginViewModel(),
              child: const LoginView(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        pageBuilder: (context, state) {
          return appFadePage(
            key: state.pageKey,
            begin: const Offset(0.04, 0),
            child: ChangeNotifierProvider(
              create: (_) => VerifyOtpViewModel(),
              child: const VerifyOtpView(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) {
          return appFadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(
              create: (_) => HomeViewModel(),
              child: const HomeView(),
            ),
          );
        },
      ),
    ],
  );
}
