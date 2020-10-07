part of 'google_auth_mixin.dart';

class LogInWithGoogleFailure implements Exception {
  final Exception exception;
  const LogInWithGoogleFailure({this.exception});
}
