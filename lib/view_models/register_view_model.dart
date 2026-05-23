import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/mvvm/base_view_model.dart';
import '../services/firebase_auth_service.dart';

class RegisterViewModel extends BaseViewModel {
  RegisterViewModel({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  final FirebaseAuthService _authService;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  bool get passwordVisible => _passwordVisible;
  bool get confirmVisible => _confirmVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _confirmVisible = !_confirmVisible;
    notifyListeners();
  }

  Future<bool> register() async {
    clearError();
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setError('Please fill all fields.');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      setError('Passwords do not match.');
      return false;
    }
    if (passwordController.text.length < 6) {
      setError('Password must be at least 6 characters.');
      return false;
    }

    setBusy(true);
    try {
      await _authService.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      return true;
    } on FirebaseAuthException catch (error) {
      setError(error.message ?? 'Could not create your account.');
      return false;
    } catch (_) {
      setError('Could not create your account.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
