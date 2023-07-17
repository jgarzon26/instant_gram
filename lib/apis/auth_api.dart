import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/core.dart';

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
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    }
  }

  FutureEither logout() async {
    try {
      final session = await _account.deleteSession(sessionId: 'current');
      return Right(session);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    }
  }
}
