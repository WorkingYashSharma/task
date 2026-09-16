import 'dart:async';

import 'package:flutter/foundation.dart';

class SplashViewModel extends ChangeNotifier {
  Timer? _timer;

  void start(VoidCallback onComplete) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), onComplete);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
