import 'dart:async';

import 'package:flutter/material.dart';

enum OtpValidation { success, missing, incomplete }

class VerifyOtpViewModel extends ChangeNotifier {
  VerifyOtpViewModel() {
    otpController.addListener(_onOtpChanged);
    focusNode.addListener(notifyListeners);
    _startTimer();
  }

  static const otpLength = 4;
  static const resendDuration = 30;

  final otpController = TextEditingController();
  final focusNode = FocusNode();

  int remainingSeconds = resendDuration;
  bool showOtpError = false;

  Timer? _timer;

  String get otp => otpController.text;
  bool get canResend => remainingSeconds <= 0;
  bool get isComplete => otp.length == otpLength;

  String digitAt(int index) {
    if (index >= otp.length) return '';
    return otp[index];
  }

  void _onOtpChanged() {
    if (otpController.text.length > otpLength) {
      otpController.value = TextEditingValue(
        text: otpController.text.substring(0, otpLength),
        selection: const TextSelection.collapsed(offset: otpLength),
      );
      return;
    }

    if (showOtpError) showOtpError = false;
    notifyListeners();
  }

  void _startTimer() {
    remainingSeconds = resendDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        remainingSeconds = 0;
        timer.cancel();
      } else {
        remainingSeconds -= 1;
      }
      notifyListeners();
    });
  }

  void resend() {
    if (!canResend) return;
    otpController.clear();
    showOtpError = false;
    _startTimer();
    notifyListeners();
  }

  OtpValidation validate() {
    if (otp.isEmpty) {
      showOtpError = true;
      notifyListeners();
      return OtpValidation.missing;
    }

    if (otp.length < otpLength) {
      showOtpError = true;
      notifyListeners();
      return OtpValidation.incomplete;
    }

    showOtpError = false;
    notifyListeners();
    return OtpValidation.success;
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.removeListener(_onOtpChanged);
    focusNode.removeListener(notifyListeners);
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
