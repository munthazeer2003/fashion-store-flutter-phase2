import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/mvvm/base_view_model.dart';
import '../models/user_profile.dart';
import '../services/user_profile_repository.dart';

class EditProfileViewModel extends BaseViewModel {
  EditProfileViewModel({UserProfileRepository? userProfileRepository})
    : _userProfileRepository = userProfileRepository ?? UserProfileRepository();

  final UserProfileRepository _userProfileRepository;
  final ImagePicker _picker = ImagePicker();
  bool _loaded = false;
  UserProfile _profile = UserProfile.empty();

  Uint8List? _selectedImageBytes;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  Uint8List? get selectedImageBytes => _selectedImageBytes;

  Future<void> loadProfile() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    setBusy(true);
    try {
      _profile = await _userProfileRepository.currentProfile();
      nameController.text = _profile.name;
      emailController.text = _profile.email;
      phoneController.text = _profile.phone;
      clearError();
    } catch (_) {
      setError('Could not load your Firebase profile.');
    } finally {
      setBusy(false);
    }
  }

  Future<bool> saveChanges() async {
    if (_profile.uid.isEmpty) {
      setError('Please login before editing your profile.');
      return false;
    }
    setBusy(true);
    try {
      _profile = UserProfile(
        uid: _profile.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        photoUrl: _profile.photoUrl,
      );
      await _userProfileRepository.saveProfile(_profile);
      clearError();
      return true;
    } catch (_) {
      setError('Could not save your Firebase profile.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) {
      return;
    }
    _selectedImageBytes = await picked.readAsBytes();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
