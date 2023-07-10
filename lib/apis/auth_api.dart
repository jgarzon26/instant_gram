import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/core.dart';

final authApiProvider = Provider((ref) {
  final account = ref.watch(accountProvider);
  return AuthApi(account: account);
});

class AuthApi {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  Future<void> loginWithFacebook() async {
    await _account.createOAuth2Session(
      provider: 'facebook',
      success: 'https://localhost:8080',
      failure: 'https://localhost:8080',
      scopes: ['public_profile'],
    );
  }

  FutureEither<User> loginWithGoogle() async {
    try {
      await _account.createOAuth2Session(
        provider: 'google',
        success: 'https://cloud.appwrite.io/v1/account/sessions/oauth2/google',
        failure: 'https://cloud.appwrite.io/v1/account/sessions/oauth2/google',
      );
      final user = await _account.get();
      return Right(user);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    }
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }
}
