import 'dart:async';

import 'models/models.dart';

abstract class UserRepository {
  UserRepository({Stream<UserModel> stream}) {
    _stream = stream;
  }

  Stream<UserModel> _stream;
  UserModel _user;

  UserModel get user => _user;

  Stream<UserModel> get userStream => _stream;

  Future<UserModel> getUser() async {
    if (_user != null) return _user;
    return fetchUser();
  }

  Future<UserModel> fetchUser();
}
