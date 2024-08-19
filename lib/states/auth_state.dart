abstract class AuthState {}

class Checking extends AuthState {}

class Checked<T> extends AuthState {
  Checked(this.value, {this.error});

  final T value;
  final Object? error;
}

class CheckError extends AuthState {
  CheckError(this.error);

  final Object error;
}
