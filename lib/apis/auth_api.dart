import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/core/core.dart';
import 'package:riverpod/riverpod.dart';

final authApiProvider = Provider((ref) {
  final account = ref.read(accountProvider);
  return AuthApi(account);
});

class AuthApi implements IAuthApi {
  final Account _account;

  AuthApi(Account account) : _account = account;

  @override
  FutureEither<Session> loginWithGoogle({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(response);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Something went wrong", stackTrace));
    }
  }
}
