import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/mvvm/base_view_model.dart';
import '../services/firebase_auth_service.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  final FirebaseAuthService _authService;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> signIn() async {
    clearError();
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setError('Please enter your email and password.');
      return false;
    }

    setBusy(true);
    try {
      await _authService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      return true;
    } on FirebaseAuthException catch (error) {
      setError(error.message ?? 'Could not sign in. Please try again.');
      return false;
    } catch (_) {
      setError('Could not sign in. Please try again.');
      return false;
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
