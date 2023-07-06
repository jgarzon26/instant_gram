import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/core/failure.dart';

typedef FutureEither<Success> = Future<Either<Failure, Success>>;
