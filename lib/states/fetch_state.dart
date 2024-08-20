abstract class FetchState {}

class Fetching extends FetchState {}

class Fetched<T> extends FetchState {
  Fetched(this.value, {this.error});

  final T value;
  final Object? error;
}

class FetchError extends FetchState {
  FetchError(this.error);

  final Object error;
}
