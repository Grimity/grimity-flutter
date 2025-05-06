import 'dart:async';

abstract class UseCase<Request, Response> {
  FutureOr<Response> execute(Request request);
}

abstract class NoParamUseCase<Response> {
  FutureOr<Response> execute();
}

abstract class NoParamNoResultUseCase {
  FutureOr<void> execute();
}
