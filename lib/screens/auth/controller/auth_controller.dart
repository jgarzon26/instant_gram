import 'package:instant_gram/apis/auth_api.dart';
import 'package:riverpod/riverpod.dart';

final authControllerProvider = StateNotifierProvider<_AuthController, bool>(
  (ref) => _AuthController(ref.watch(authApiProvider)),
);

class _AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  _AuthController(AuthApi authApi)
      : _authApi = authApi,
        super(false);

  void loginWithGoogle({
    required String email,
    required String password,
  }) async {
    state = true;
    final response = await _authApi.loginWithGoogle(
      email: email,
      password: password,
    );
    state = false;
    response.fold(
      (failure) => print(failure.message),
      (session) => print(session),
    );
  }
}
