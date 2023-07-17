import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:instant_gram/apis/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/core.dart';

final authControllerProvider = StateNotifierProvider<_AuthController, bool>(
  (ref) => _AuthController(ref.watch(authApiProvider)),
);

class _AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  String? _userId;

  String? get userId => _userId;

  _AuthController(AuthApi authApi)
      : _authApi = authApi,
        super(false);

  void loginWithOAuth2(BuildContext context, String provider) async {
    state = true;
    final response = await _authApi.loginWithOAuth2(provider);
    _userId = await _authApi.getUserDetails().then((value) => value.$id);
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
      },
      (session) {
        Navigator.pushReplacementNamed(context, '/home');
        showSnackbar(context, "Logged in successfully");
      },
    );
    state = false;
  }

  Future<User> getUserDetails() async {
    final user = await _authApi.getUserDetails();
    return user;
  }

  void logout(BuildContext context) async {
    state = true;
    final response = await _authApi.logout();
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
      },
      (session) {
        Navigator.pushReplacementNamed(context, '/');
        showSnackbar(context, "Logged out successfully");
      },
    );
    state = false;
  }
}
