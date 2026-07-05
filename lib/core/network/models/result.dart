sealed class Result<S, E> {
  const Result();
}

final class Success<S, E> extends Result<S, E> {
  const Success(this.value);

  final S value;
}

final class Failure<S, E> extends Result<S, E> {
  const Failure(this.message, {this.code});

  final String? message;
  final String? code;
}
