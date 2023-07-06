import 'package:appwrite/models.dart';
import 'package:instant_gram/core/core.dart';

abstract class IAuthApi {
  FutureEither<Session> loginWithGoogle({
    required String email,
    required String password,
  });
}
