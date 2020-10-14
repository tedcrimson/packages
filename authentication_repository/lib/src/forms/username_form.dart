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
  UsernameForm.dirty({String value = ''}) : super.dirty(value, true);

  UsernameForm.pure() : super.pure(true);

  static constructor(String value, bool requiredField) => UsernameForm.dirty(value: value);

  @override
  FieldError validator(String value) {
    if (value != null) {
      if (value.length < 4) {
        return UserShortError();
      }
    }
    return UserInvalidError();
  }
}
