import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:instant_gram/apis/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/appwrite_providers.dart';

final authControllerProvider = StateNotifierProvider<_AuthController, bool>(
  (ref) => _AuthController(ref.watch(authApiProvider)),
);

class _AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  User? user;

  _AuthController(AuthApi authApi)
      : _authApi = authApi,
        super(false);

  void loginWithGoogle(WidgetRef ref) async {
    try {
      state = true;
      await _authApi.loginWithGoogle();
      user = await ref.read(accountProvider).get();
      print(user?.email ?? 'No email');
      state = false;
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}
