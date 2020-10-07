import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'exceptions.dart';

typedef OnComplete = Future Function(GoogleSignInAccount user);

mixin GoogleAuthenticationMixin<T> on FirebaseAuthenticationRepository<T> {
  GoogleSignIn _googleSignIn;

  Future signInWithGoogle({List<String> scopes, OnComplete onComplete}) async {
    try {
      if (_googleSignIn == null) {
        _googleSignIn = GoogleSignIn.standard(scopes: scopes, hostedDomain: '');
      }
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      await onComplete(googleUser);
      logIn();
    } on Exception catch (e) {
      throw LogInWithGoogleFailure(exception: e);
    }
  }
}
