import 'package:appwrite/appwrite.dart';
import 'package:instant_gram/core/appwrite_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authApiProvider = Provider((ref) => AuthApi(ref.read(accountProvider)));

class AuthApi {
  final Account _account;

  AuthApi(this._account);

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
    );
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }
}
