import '../core/mvvm/base_view_model.dart';

class SettingsViewModel extends BaseViewModel {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  bool get darkMode => _darkMode;
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setPushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void setEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }
}
