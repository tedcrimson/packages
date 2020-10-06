import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc<T, TT> extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.userStream.listen(
      (T user) => add(AuthenticationUserChanged<T>(user)),
    );
  }

  final AuthenticationRepository<T, TT> _authenticationRepository;
  StreamSubscription<T> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged<T> event,
  ) {
    return event.user != null
        ? AuthenticationState<T>.authenticated(event.user)
        : AuthenticationState<T>.unauthenticated();
  }

  // Future<UserModel> _tryGetUser() async {
  //   try {
  //     final user = await _userRepository.getUser();
  //     return user;
  //   } on Exception {
  //     return null;
  //   }
  // }

}
