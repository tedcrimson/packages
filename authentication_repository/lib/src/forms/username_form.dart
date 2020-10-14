import 'package:authentication_repository/src/forms/string_form.dart';

import 'field_form.dart';

enum UsernameValidationError { invalid, isShort }

class UserShortError extends FieldError {
  @override
  String get text => 'Is Short';
}

class UserInvalidError extends FieldError {
  @override
  String get text => 'not correct';
}

class UsernameForm extends StringFieldForm {
  UsernameForm.dirty({String value, bool requiredField}) : super.dirty(value: value, requiredField: requiredField);

  UsernameForm.pure() : super.pure(true);

  static constructor(String value, bool requiredField) =>
      UsernameForm.dirty(value: value, requiredField: requiredField);

  @override
  FieldError validator(String value) {
    var error = super.validator(value);
    if (value != null) {
      if (value.length < 4) {
        error = UserShortError();
      }
    } else
      error = UserInvalidError();
    return error;
  }
}
