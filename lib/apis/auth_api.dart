import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/core/appwrite_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/typedefs.dart';

final authApiProvider = Provider((ref) => AuthApi(ref.read(accountProvider)));

class AuthApi {
  final Account _account;
  AuthApi(this._account);

  Future<User> getUserDetails() async {
    final user = await _account.get();
    return user;
  }

  FutureEither loginWithOAuth2(String provider) async {
    try {
      final session = await _account.createOAuth2Session(
        provider: provider,
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
