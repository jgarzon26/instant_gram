import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/core/core.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef GetEither<T> = Either<Failure, T>;
