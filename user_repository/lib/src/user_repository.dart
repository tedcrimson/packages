import 'dart:async';

import 'models/models.dart';

abstract class UserRepository {
  UserModel _user;

  StreamSubscription<UserModel> _controller;

  UserRepository({Stream<UserModel> stream}) : assert(stream != null) {
    _controller = stream.listen((event) {
      _user = event;
    });
  }

  void dispose() {
    _controller?.cancel();
  }

  UserModel get user => _user;

  Future<UserModel> getUser() async {
    if (_user != null) return _user;
    return fetchUser();
  }

  Future<UserModel> fetchUser();
}
