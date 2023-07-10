import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
