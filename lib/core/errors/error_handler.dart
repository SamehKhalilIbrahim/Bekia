import 'package:dartz/dartz.dart';

import 'failures.dart';

Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
  try {
    return right(await action());
  } catch (e) {
    return left(Failure.fromException(e));
  }
}
