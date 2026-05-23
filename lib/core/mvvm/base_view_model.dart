import 'package:flutter/foundation.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  String? _errorMessage;
  bool _isDisposed = false;

  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  bool get isDisposed => _isDisposed;

  void setBusy(bool value) {
    if (_isDisposed || _isBusy == value) {
      return;
    }
    _isBusy = value;
    notifyListeners();
  }

  void setError(String? message) {
    if (_isDisposed) {
      return;
    }
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_isDisposed || _errorMessage == null) {
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_isDisposed) {
      return;
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
