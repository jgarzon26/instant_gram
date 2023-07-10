import 'package:instant_gram/apis/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<_AuthController, bool>(
  (ref) {
    return _AuthController(authApi: ref.watch(authApiProvider));
  },
);

class _AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  _AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  void loginWithGoogle() async {
    state = true;
    final response = await _authApi.loginWithGoogle();
    response.fold(
      (failure) => print(failure.message),
      (user) => print(user.email),
    );
    state = false;
  }
}
