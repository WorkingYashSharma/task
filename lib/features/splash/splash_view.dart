import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_assets.dart';
import 'package:task/core/constants/app_routes.dart';
import 'package:task/core/theme/app_colors.dart';
import 'package:task/core/widgets/fade_slide_in.dart';
import 'package:task/features/splash/splash_texts.dart';
import 'package:task/features/splash/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashViewModel>().start(() {
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Stack(
          fit: StackFit.expand,
          children: [
            FadeSlideIn(
              duration: const Duration(milliseconds: 800),
              dy: 0,
              child: Image.asset(AppAssets.vector, fit: BoxFit.contain),
            ),
            const Center(
              child: FadeSlideIn(
                duration: Duration(milliseconds: 700),
                dy: 10,
                scaleBegin: 0.94,
                child: _Logo(),
              ),
            ),
            const SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FadeSlideIn(
                  delay: Duration(milliseconds: 220),
                  duration: Duration(milliseconds: 560),
                  dy: 8,
                  child: _Tagline(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.3),
        border: Border.all(color: AppColors.border, width: 1.17),
      ),
      child: Image.asset(AppAssets.logo, width: 117, fit: BoxFit.contain),
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Text(
        SplashTexts.tagline,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          height: 1,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
