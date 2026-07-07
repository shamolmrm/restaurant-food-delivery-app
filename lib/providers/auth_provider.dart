import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/dummy_data.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyAuthToken);
    if (token != null) {
      _user = dummyUser;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (email == AppConstants.demoEmail && password == AppConstants.demoPassword ||
        email.isNotEmpty && password.length >= 6) {
      _user = dummyUser.copyWith(email: email);
      _status = AuthStatus.authenticated;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyAuthToken, 'demo_token_${DateTime.now().millisecondsSinceEpoch}');
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _user = UserModel(
      id: 'u_new_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      loyaltyPoints: 100,
      totalSavings: 0,
      totalOrders: 0,
      createdAt: DateTime.now(),
    );
    _status = AuthStatus.authenticated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAuthToken, 'demo_token_new');
    notifyListeners();
    return true;
  }

  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return otp == '123456' || otp.length == 6;
  }

  Future<void> logout() async {
    _status = AuthStatus.unauthenticated;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAuthToken);
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
