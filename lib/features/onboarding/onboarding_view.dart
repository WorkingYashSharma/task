import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:task/core/constants/app_assets.dart';
import 'package:task/core/constants/app_routes.dart';
import 'package:task/core/theme/app_colors.dart';
import 'package:task/core/widgets/fade_slide_in.dart';
import 'package:task/features/onboarding/onboarding_texts.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.onboardingGradientStart,
                AppColors.onboardingGradientEnd,
              ],
            ),
          ),
          child: const Stack(
            fit: StackFit.expand,
            children: [
              _Background(),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: _Content(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            AppAssets.onboardingImage,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            color: AppColors.onboardingGradientEnd,
            colorBlendMode: BlendMode.lighten,
          ),
        ),
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.onboardingImageFade,
                  AppColors.onboardingGradientEnd,
                ],
                stops: [0, 0.48, 0.66, 0.84],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: FadeSlideIn(
            duration: Duration(milliseconds: 420),
            dy: 8,
            child: _SkipButton(),
          ),
        ),
        const Spacer(),
        FadeSlideIn(
          delay: const Duration(milliseconds: 80),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.99),
            ),
            child: Image.asset(AppAssets.logo, width: 78, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 19),
        FadeSlideIn(
          delay: const Duration(milliseconds: 140),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              OnboardingTexts.title,
              style: textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontSize: 37.73,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7.34),
        FadeSlideIn(
          delay: const Duration(milliseconds: 200),
          child: Text(
            OnboardingTexts.subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 12.58,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 19),
        FadeSlideIn(
          delay: const Duration(milliseconds: 280),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              onPressed: () => context.go(AppRoutes.login),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.continueButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.48),
                ),
                textStyle: textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text(OnboardingTexts.continueLabel),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.login),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          OnboardingTexts.skip,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.skipText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      ),
    );
  }
}
