import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_assets.dart';
import 'package:task/core/constants/app_routes.dart';
import 'package:task/core/theme/app_colors.dart';
import 'package:task/core/widgets/app_snack_bars.dart';
import 'package:task/core/widgets/fade_slide_in.dart';
import 'package:task/features/auth/verify_otp_texts.dart';
import 'package:task/features/auth/verify_otp_view_model.dart';

void _submitOtp(BuildContext context) {
  FocusScope.of(context).unfocus();
  final vm = context.read<VerifyOtpViewModel>();

  switch (vm.validate()) {
    case OtpValidation.missing:
      AppSnackBars.missing(context, VerifyOtpTexts.otpRequired);
    case OtpValidation.incomplete:
      AppSnackBars.warning(context, VerifyOtpTexts.otpIncomplete);
    case OtpValidation.success:
      context.go(AppRoutes.home);
  }
}

void _goBack(BuildContext context) {
  FocusScope.of(context).unfocus();
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(AppRoutes.login);
}

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key});

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
              _Header(height: height * 0.22),
              Column(
                children: [
                  const SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: FadeSlideIn(
                        duration: Duration(milliseconds: 400),
                        dy: 8,
                        child: _NavBar(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
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

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _goBack(context),
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.verifyBackButton,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          VerifyOtpTexts.appBarTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
          const _ContinueButton(),
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
          width: 91,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.otpIconFill,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.border, width: 1.31),
          ),
          child: Image.asset(AppAssets.phoneIcon, width: 42, height: 60),
        ),
        const SizedBox(height: 21),
        Text(
          VerifyOtpTexts.title,
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          VerifyOtpTexts.subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.verifySubtitle,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 21),
        Text(
          VerifyOtpTexts.enterCode,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 15),
        const _OtpFields(),
        const SizedBox(height: 20),
        const _ResendRow(),
      ],
    );
  }
}

class _OtpFields extends StatefulWidget {
  const _OtpFields();

  @override
  State<_OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<_OtpFields> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<VerifyOtpViewModel>().focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VerifyOtpViewModel>();

    return AutofillGroup(
      child: SizedBox(
        height: 57.64,
        child: Stack(
          children: [
            Row(
              children: [
                for (var i = 0; i < VerifyOtpViewModel.otpLength; i++) ...[
                  if (i > 0) const SizedBox(width: 10.96),
                  _OtpBox(
                    digit: vm.digitAt(i),
                    isFilled: vm.digitAt(i).isNotEmpty,
                    showError: vm.showOtpError,
                  ),
                ],
              ],
            ),
            Positioned.fill(
              child: TextField(
                controller: vm.otpController,
                focusNode: vm.focusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    VerifyOtpViewModel.otpLength,
                  ),
                ],
                showCursor: false,
                enableInteractiveSelection: true,
                style: const TextStyle(color: Colors.transparent, fontSize: 1),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: '',
                  isCollapsed: true,
                ),
                onSubmitted: (_) => _submitOtp(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.digit,
    required this.isFilled,
    required this.showError,
  });

  final String digit;
  final bool isFilled;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final borderColor = isFilled
        ? AppColors.continueButton
        : showError
        ? AppColors.snackError
        : AppColors.otpEmptyBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: 57.64,
      height: 57.64,
      padding: const EdgeInsets.symmetric(vertical: 9.43, horizontal: 8.38),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.48),
        border: Border.all(color: borderColor, width: isFilled ? 1 : 1.05),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            offset: const Offset(0, 3.14),
            blurRadius: 4.19,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: isFilled ? Colors.black : AppColors.otpPlaceholder,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        child: Text(isFilled ? digit : '−'),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VerifyOtpViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final baseStyle = textTheme.bodySmall?.copyWith(
      color: vm.canResend ? AppColors.continueButton : AppColors.resendCode,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 0.9,
    );

    return GestureDetector(
      onTap: vm.canResend ? vm.resend : null,
      child: Text.rich(
        TextSpan(
          text: VerifyOtpTexts.resendCode,
          style: baseStyle,
          children: [
            if (!vm.canResend)
              TextSpan(
                text: ' ( ${vm.remainingSeconds}sec )',
                style: const TextStyle(color: AppColors.continueButton),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 41,
      child: FilledButton(
        onPressed: () => _submitOtp(context),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.continueButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          textStyle: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 0.9,
            letterSpacing: 0,
            color: Colors.white,
          ),
        ),
        child: const Text(VerifyOtpTexts.continueLabel),
      ),
    );
  }
}
