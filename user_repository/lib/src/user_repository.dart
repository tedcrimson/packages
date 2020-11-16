import 'dart:async';

import 'models/models.dart';

abstract class UserRepository<T extends UserModel> {
  UserRepository({Stream<T> stream}) {
    _stream = stream;
  }

  Stream<T> _stream;
  T _user;

  T get user => _user;

  Stream<T> get userStream => _stream;

  Future<T> getUser() async {
    if (_user != null) return _user;
    return fetchUser();
  }

  Future<T> fetchUser();
}
