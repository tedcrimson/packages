import 'credential_form.dart';

enum UsernameValidationError { invalid, isShort }

class UsernameForm extends CredentialForm<UsernameValidationError> {
  const UsernameForm.pure() : super.pure();
  const UsernameForm.dirty([String value = '']) : super.dirty(value);
  static constructor(String value) => UsernameForm.dirty(value);

  @override
  UsernameValidationError validator(String value) {
    if (value != null) {
      if (value.length < 4) {
        return UsernameValidationError.isShort;
      }
    }
    return UsernameValidationError.invalid;
    // return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }

  @override
  String get errorText {
    switch (error) {
      case UsernameValidationError.isShort:
        return 'Is Short';
      case UsernameValidationError.invalid:
        return 'not correct';
    }
    return null;
  }
}
