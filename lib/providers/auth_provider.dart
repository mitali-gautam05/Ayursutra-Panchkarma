// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _userRole;
  String? _authToken;
  String? _signupMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userRole => _userRole;
  String? get authToken => _authToken;
  String? get signupMessage => _signupMessage;

  // --- Login Method ---
  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _signupMessage = null; 
    notifyListeners();

    try {
      final response = await _authService.login(email: email, password: password, role: role);

      _userRole = role;
      _authToken = response['token'];
      _isLoading = false;
      notifyListeners();
      return true; 
      
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

  // --- Sign Up Method ---
  Future<bool> signup({
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true; 
    _errorMessage = null;
    _signupMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signup(email: email, password: password, role: role);
      
      _signupMessage = response['message'];
      _isLoading = false;
      notifyListeners();
      return true; 
      
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }
}