import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

// 1.0
class FirebaseAuthenticationRepository<T> extends AuthenticationRepository<User, T> {
  FirebaseAuthenticationRepository({
    FirebaseAuth firebaseAuth,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super() {
    _userSubscription = userStream.listen((event) {
      fireUser = event;
    });
  }

  final FirebaseAuth firebaseAuth;

  User fireUser;
  StreamSubscription<User> _userSubscription;

  @override
  Stream<User> get userStream {
    return firebaseAuth.authStateChanges();
  }

  String get userId => fireUser.uid;

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  Future signUp({@required List fields});

  @override
  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await super.logInWithEmailAndPassword(email: email, password: password);
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
