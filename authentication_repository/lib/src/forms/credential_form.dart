import 'package:formz/formz.dart';

abstract class CredentialForm<T> extends FormzInput<String, T> {
  const CredentialForm.pure() : super.pure(null);
  const CredentialForm.dirty([String value = '']) : super.dirty(value);
  String get errorText;
}
