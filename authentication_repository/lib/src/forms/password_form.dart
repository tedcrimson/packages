import 'credential_form.dart';

enum PasswordValidationError {
  morethaneight,
  onecapital,
  onenumber,
  isempty,
}

class PasswordForm extends CredentialForm<PasswordValidationError> {
  const PasswordForm.pure() : super.pure();
  const PasswordForm.dirty([String value = '']) : super.dirty(value);
  static constructor(String value) => PasswordForm.dirty(value);

  // static final _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError validator(String value) {
    PasswordValidationError error;
    if (value == null) {
      error = null;
    } else if (value.isEmpty) {
      error = PasswordValidationError.isempty;
    } else if (value.length < 8 && value.isNotEmpty) {
      error = PasswordValidationError.morethaneight;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      error = PasswordValidationError.onecapital;
    } else if (!value.contains(RegExp(r'\d'))) error = PasswordValidationError.onenumber;

    return error;
  }

  @override
  String get errorText {
    String errorText;
    switch (error) {
      case PasswordValidationError.morethaneight:
        errorText = 'Password should contains more then 8 character';
        break;
      case PasswordValidationError.onecapital:
        errorText = 'Password should contain at least one capital letter';
        break;
      case PasswordValidationError.onenumber:
        errorText = 'Password should contain at least one number';
        break;
      case PasswordValidationError.isempty:
        errorText = 'Password is empty';
        break;
    }
    return errorText;
  }
}
