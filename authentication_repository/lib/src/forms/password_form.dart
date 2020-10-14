import 'package:authentication_repository/src/forms/field_form.dart';
import 'package:authentication_repository/src/forms/string_form.dart';

class MoreThanEightError extends FieldError {
  @override
  String get text => 'Password should contains more then 8 character';
}

class OneCapitalError extends FieldError {
  @override
  String get text => 'Password should contain at least one capital letter';
}

class OneNumberError extends FieldError {
  @override
  String get text => 'Password should contain at least one number';
}

class PasswordForm extends StringFieldForm {
  const PasswordForm.dirty({String value, bool requiredField})
      : super.dirty(value: value, requiredField: requiredField);

  const PasswordForm.pure({bool requiredField = false}) : super.pure(requiredField);
  static constructor(String value, bool requiredField) =>
      PasswordForm.dirty(value: value, requiredField: requiredField);

  // static final _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  FieldError validator(String value) {
    var error = super.validator(value);
    if (error == null) {
      if (value.length < 8 && value.isNotEmpty) {
        error = MoreThanEightError();
      } else if (!value.contains(RegExp(r'[A-Z]'))) {
        error = OneCapitalError();
      } else if (!value.contains(RegExp(r'\d'))) {
        error = OneNumberError();
      }
    }

    return error;
  }
}
