import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_assets.dart';
import 'package:task/core/constants/app_routes.dart';
import 'package:task/core/theme/app_colors.dart';
import 'package:task/core/widgets/app_snack_bars.dart';
import 'package:task/core/widgets/fade_slide_in.dart';
import 'package:task/features/auth/login_texts.dart';
import 'package:task/features/auth/login_view_model.dart';

void _submitLogin(BuildContext context) {
  FocusScope.of(context).unfocus();
  final vm = context.read<LoginViewModel>();

  switch (vm.validate()) {
    case LoginValidation.phoneMissing:
      AppSnackBars.missing(context, LoginTexts.phoneRequired);
    case LoginValidation.phoneIncomplete:
      AppSnackBars.warning(context, LoginTexts.phoneIncomplete);
    case LoginValidation.phoneInvalid:
      AppSnackBars.error(context, LoginTexts.phoneInvalid);
    case LoginValidation.termsMissing:
      AppSnackBars.warning(context, LoginTexts.termsRequired);
    case LoginValidation.success:
      context.push(AppRoutes.verifyOtp);
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.loginHero,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Header(height: height * 0.28),
              Column(
                children: [
                  SizedBox(height: height * 0.235),
                  const Expanded(
                    child: ClipRect(
                      child: FadeSlideIn(
                        duration: Duration(milliseconds: 520),
                        dy: 22,
                        child: _Sheet(),
                      ),
                    ),
                  ),
                ],
              ),
              const SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: FadeSlideIn(
                      duration: Duration(milliseconds: 420),
                      dy: 8,
                      child: _SkipButton(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.loginBackground,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            const ColoredBox(color: AppColors.loginOverlay),
          ],
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.home),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          LoginTexts.skip,
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

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 37, 24, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: _Form(),
            ),
          ),
          const _Actions(),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 12),
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11.73),
            border: Border.all(color: AppColors.border, width: 0.63),
          ),
          child: Image.asset(AppAssets.logo, width: 90, fit: BoxFit.contain),
        ),
        const SizedBox(height: 24),
        Text(
          LoginTexts.title,
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          LoginTexts.subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.loginSubtitle,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 23),
        Text(
          LoginTexts.phoneNumber,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        const _PhoneInput(),
        const SizedBox(height: 25),
        const _TermsRow(),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 58,
          height: 44,
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
          decoration: BoxDecoration(
            color: AppColors.loginInputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.countryCodeBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.18),
                offset: const Offset(0, 3),
                blurRadius: 4,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(
                  LoginTexts.countryCode,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: -1.2,
                  ),
                ),
                SizedBox(width: 7),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: vm.phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitLogin(context),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              cursorColor: AppColors.continueButton,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.skipText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
              ),
              decoration: InputDecoration(
                hintText: LoginTexts.phoneHint,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: AppColors.loginHint,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: 0,
                ),
                prefixIcon: const Icon(
                  Icons.phone_iphone_outlined,
                  size: 18,
                  color: AppColors.loginPhoneIcon,
                ),
                filled: true,
                fillColor: AppColors.loginInputFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: vm.showPhoneError
                        ? AppColors.snackError
                        : AppColors.border,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: vm.showPhoneError
                        ? AppColors.snackError
                        : AppColors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: vm.showPhoneError
                        ? AppColors.snackError
                        : AppColors.continueButton,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppColors.loginPrefix,
      fontSize: 11.12,
      fontWeight: FontWeight.w500,
      height: 1.2,
    );

    return GestureDetector(
      onTap: vm.toggleAgreedToTerms,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 12,
            height: 12,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: vm.agreedToTerms ? AppColors.continueButton : Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: vm.agreedToTerms
                    ? AppColors.continueButton
                    : AppColors.loginCheckboxBorder,
                width: 1.2,
              ),
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: vm.agreedToTerms ? 1 : 0,
              child: const Icon(Icons.check, size: 9, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text.rich(
              TextSpan(
                text: LoginTexts.termsPrefix,
                style: textStyle,
                children: [
                  const TextSpan(
                    text: LoginTexts.terms,
                    style: TextStyle(
                      color: AppColors.continueButton,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.continueButton,
                    ),
                  ),
                  TextSpan(text: LoginTexts.termsAnd, style: textStyle),
                  const TextSpan(
                    text: LoginTexts.policy,
                    style: TextStyle(
                      color: AppColors.continueButton,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.continueButton,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton(
            onPressed: () => _submitLogin(context),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.continueButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8.8),
              textStyle: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: 0,
                color: Colors.white,
              ),
            ),
            child: const Text(LoginTexts.sendOtp),
          ),
        ),
        const SizedBox(height: 33),
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.loginDivider, height: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                LoginTexts.orContinueWith,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.loginDivider, height: 1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton.icon(
            onPressed: () {
              AppSnackBars.missing(context, LoginTexts.emailComingSoon);
            },
            icon: const Icon(
              Icons.mail_outline_rounded,
              size: 18,
              color: AppColors.continueButton,
            ),
            label: const Text(LoginTexts.continueWithEmail),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.loginEmailButton,
              foregroundColor: Colors.black,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              textStyle: textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
