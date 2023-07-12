import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/core/appwrite_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/typedefs.dart';

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

  Future getUserDetails() async {
    return _account.get();
  }

  FutureEither loginWithGoogle() async {
    try {
      final session = await _account.createOAuth2Session(
        provider: 'google',
      );
      return Right(session);
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Something went wrong');
    }
  }

  FutureEither logout() async {
    try {
      final session = await _account.deleteSession(sessionId: 'current');
      return Right(session);
    } on AppwriteException catch (e) {
      return Left(e.message ?? 'Something went wrong');
    }
  }
}
