import 'dart:async';
import 'package:meta/meta.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepository<T, TT> {
  AuthenticationRepository() {
    _subscription = _controller.stream.listen((event) {
      _status = event;
    });
  }

  final _controller = StreamController<AuthenticationStatus>();
  AuthenticationStatus _status;
  StreamSubscription<AuthenticationStatus> _subscription;

  Stream<T> get userStream;

  AuthenticationStatus get status => _status;

  @mustCallSuper
  Future logInWithEmailAndPassword({@required String email, @required String password}) async {
    assert(email != null);
    assert(password != null);
    await Future.delayed(const Duration(milliseconds: 300), logIn);
  }

  @mustCallSuper
  Future loginWithUserName({@required String username, @required String password}) async {
    assert(username != null);
    assert(password != null);
    await Future.delayed(const Duration(milliseconds: 300), logIn);
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void logIn() {
    _controller.add(AuthenticationStatus.authenticated);
  }

  void dispose() {
    _controller.close();
    _subscription.cancel();
  }

  @mustCallSuper
  Future signUp({@required List fields}) async {
    assert(fields != null);
    await Future.delayed(const Duration(milliseconds: 300), logIn);
  }
}
