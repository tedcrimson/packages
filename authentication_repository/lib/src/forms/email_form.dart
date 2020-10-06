import 'credential_form.dart';

enum EmailValidationError { invalid }

class EmailForm extends CredentialForm<EmailValidationError> {
  const EmailForm.pure() : super.pure();
  const EmailForm.dirty([String value = '']) : super.dirty(value);
  static constructor(String value) => EmailForm.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    // r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  EmailValidationError validator(String value) {
    return value == null || _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }

  String get errorText {
    switch (error) {
      case EmailValidationError.invalid:
        return 'Enter Valid Email';
    }
    return null;
  }
}
