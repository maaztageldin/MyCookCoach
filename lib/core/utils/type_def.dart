
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;