import 'package:appwrite/appwrite.dart';
import 'package:instant_gram/core/appwrite_providers.dart';
import 'package:riverpod/riverpod.dart';

final authApiProvider = Provider((ref) => _AuthApi(ref.read(accountProvider)));

class _AuthApi {
  final Account _account;

  _AuthApi(this._account);

  Future<void> loginWithFacebook() async {
    await _account.createOAuth2Session(
      provider: 'facebook',
      success: 'https://localhost:8080',
      failure: 'https://localhost:8080',
      scopes: ['public_profile'],
    );
  }

  Future<void> loginWithGoogle() async {
    await _account.createOAuth2Session(
      provider: 'google',
      success: 'https://localhost:8080',
      failure: 'https://localhost:8080',
      scopes: ['profile'],
    );
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }
}
