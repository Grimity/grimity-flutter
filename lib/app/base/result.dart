abstract class Result<T> {
  static Result<T> failure<T>(Exception error) => Failure<T>(error);

  static Result<T> success<T>(T value) => Success<T>(value);

  T getOrThrow() {
    return this is Success ? (this as Success).value : throw (this as Failure).error;
  }

  R fold<R>({required R Function(T value) onSuccess, required R Function(Exception e) onFailure}) {
    if (this is Success) {
      return onSuccess((this as Success).value);
    } else {
      final error = (this as Failure).error;
      // Preserve the original exception so callers can inspect HTTP status,
      // response data, request information, and the underlying error.
      return onFailure(error);
    }
  }

  bool get isSuccess => fold(onSuccess: (_) => true, onFailure: (_) => false);
  bool get isFailure => fold(onSuccess: (_) => false, onFailure: (_) => true);

  T get data => fold(onSuccess: (value) => value, onFailure: (error) => throw error);
  Exception get error =>
      fold(onSuccess: (_) => throw Exception('Success result has no error'), onFailure: (error) => error);
}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Failure<T> extends Result<T> {
  @override
  final Exception error;

  Failure(this.error);
}
