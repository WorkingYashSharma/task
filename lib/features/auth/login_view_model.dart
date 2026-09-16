import 'package:flutter/material.dart';

enum LoginValidation {
  success,
  phoneMissing,
  phoneIncomplete,
  phoneInvalid,
  termsMissing,
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel() {
    phoneController.addListener(_onPhoneChanged);
  }

  final phoneController = TextEditingController();

  bool agreedToTerms = false;
  bool showPhoneError = false;

  String get phone => phoneController.text.trim();

  void _onPhoneChanged() {
    if (showPhoneError) {
      showPhoneError = false;
    }
    notifyListeners();
  }

  void toggleAgreedToTerms() {
    agreedToTerms = !agreedToTerms;
    notifyListeners();
  }

  LoginValidation validate() {
    if (phone.isEmpty) {
      showPhoneError = true;
      notifyListeners();
      return LoginValidation.phoneMissing;
    }

    if (phone.length < 10) {
      showPhoneError = true;
      notifyListeners();
      return LoginValidation.phoneIncomplete;
    }

    if (!_isValidIndianMobile(phone)) {
      showPhoneError = true;
      notifyListeners();
      return LoginValidation.phoneInvalid;
    }

    if (!agreedToTerms) {
      showPhoneError = false;
      notifyListeners();
      return LoginValidation.termsMissing;
    }

    showPhoneError = false;
    notifyListeners();
    return LoginValidation.success;
  }

  bool _isValidIndianMobile(String value) {
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) return false;
    if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) return false;
    return true;
  }

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }
}
