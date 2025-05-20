import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UseCase<Request, Response> {
  FutureOr<Response> execute(Request request);
}

abstract class ParamWithRefUseCase<Request, Response> {
  FutureOr<Response> execute(Request request, Ref ref);
}

abstract class NoParamUseCase<Response> {
  FutureOr<Response> execute();
}

abstract class NoParamNoResultUseCase {
  FutureOr<void> execute();
}
