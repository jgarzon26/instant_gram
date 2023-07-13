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

  _AuthController(AuthApi authApi)
      : _authApi = authApi,
        super(false);

  void loginWithFacebook(BuildContext context) async {
    state = true;
    final response = await _authApi.loginWithFacebook();
    response.fold(
      (l) {
        showSnackbar(context, l);
      },
      (r) {
        Navigator.pushReplacementNamed(context, '/home');
        showSnackbar(context, "Logged in successfully");
      },
    );
    state = false;
  }

  void loginWithGoogle(BuildContext context) async {
    state = true;
    final response = await _authApi.loginWithGoogle();
    response.fold(
      (l) {
        showSnackbar(context, l);
      },
      (r) {
        Navigator.pushReplacementNamed(context, '/home');
        showSnackbar(context, "Logged in successfully");
      },
    );
    state = false;
  }

  Future<User> getUserDetails(BuildContext context) async {
    state = true;
    final user = await _authApi.getUserDetails();

    state = false;
    return user;
  }

  void logout(BuildContext context) async {
    state = true;
    final response = await _authApi.logout();
    response.fold(
      (l) {
        showSnackbar(context, l);
      },
      (r) {
        Navigator.pushReplacementNamed(context, '/');
        showSnackbar(context, "Logged out successfully");
      },
    );
    state = false;
  }
}
