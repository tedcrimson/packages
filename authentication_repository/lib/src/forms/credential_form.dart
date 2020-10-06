import 'package:formz/formz.dart';

abstract class CredentialForm<T> extends FormzInput<String, T> {
  const CredentialForm.dirty([String value = '']) : super.dirty(value);

  const CredentialForm.pure() : super.pure(null);

  String get errorText;
}
