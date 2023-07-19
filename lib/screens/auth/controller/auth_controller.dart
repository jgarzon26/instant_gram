import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:instant_gram/apis/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';

final authControllerProvider = StateNotifierProvider<_AuthController, bool>(
  (ref) => _AuthController(ref.watch(authApiProvider)),
);

final getUserDetailsProvider =
    FutureProvider((ref) => ref.watch(authApiProvider).getUserDetails());

class _AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  _AuthController(AuthApi authApi)
      : _authApi = authApi,
        super(false);

  void loginWithOAuth2(
      BuildContext context, WidgetRef ref, String provider) async {
    state = true;
    final response = await _authApi.loginWithOAuth2(provider);
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
        state = false;
      },
      (session) async {
        await _authApi.getUserDetails().then((user) {
          ref
              .read(allPostsProvider.notifier)
              .addLikedPostToListOfCurrentUser(context, ref, user.$id);
        });
      },
    );
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
