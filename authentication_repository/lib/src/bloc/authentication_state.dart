part of 'authentication_bloc.dart';

class AuthenticationState<T> extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  const AuthenticationState.authenticated(T user) : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.unknown() : this._();

  final AuthenticationStatus status;
  final T user;

  @override
  List<Object> get props => [status, user];
}
