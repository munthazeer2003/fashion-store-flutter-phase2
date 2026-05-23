import 'dart:async';

import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mvvm/base_view_model.dart';

class SplashViewModel extends BaseViewModel {
  Timer? _timer;
  bool _started = false;

  void startOnce(VoidCallback onComplete) {
    if (_started) {
      return;
    }
    _started = true;
    _timer?.cancel();
    _timer = Timer(
      const Duration(seconds: AppConstants.splashDurationSeconds),
      onComplete,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
