import 'dart:async';

import 'models/models.dart';

abstract class UserRepository {
  UserRepository({Stream<UserModel> stream}) {
    if (stream != null)
      _controller = stream.listen((event) {
        _user = event;
      });
  }

  StreamSubscription<UserModel> _controller;
  UserModel _user;

  void dispose() {
    _controller?.cancel();
  }

  UserModel get user => _user;

  StreamSubscription get usetSubscription => _controller;

  Future<UserModel> getUser() async {
    if (_user != null) return _user;
    return fetchUser();
  }

  Future<UserModel> fetchUser();
}
