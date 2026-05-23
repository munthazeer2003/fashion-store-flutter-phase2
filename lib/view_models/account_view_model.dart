import '../core/mvvm/base_view_model.dart';
import '../models/user_profile.dart';
import '../services/firebase_auth_service.dart';
import '../services/user_profile_repository.dart';

class AccountViewModel extends BaseViewModel {
  AccountViewModel({
    UserProfileRepository? userProfileRepository,
    FirebaseAuthService? authService,
  }) : _userProfileRepository =
           userProfileRepository ?? UserProfileRepository(),
       _authService = authService ?? FirebaseAuthService();

  final UserProfileRepository _userProfileRepository;
  final FirebaseAuthService _authService;
  bool _loaded = false;
  UserProfile _profile = UserProfile.empty();

  String get userName => _profile.name;
  String get userEmail => _profile.email;
  String get profileImage => 'assets/images/profile/profile.png';

  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      _profile = await _userProfileRepository.currentProfile();
      clearError();
    } catch (_) {
      setError('Could not load your Firebase profile.');
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
