import 'package:authentication_repository/src/forms/field_form.dart';
import 'package:authentication_repository/src/forms/string_form.dart';

class EmailValidationError extends FieldError {
  @override
  String get text => 'enter_valid_email';
}

class EmailForm extends StringFieldForm {
  const EmailForm.dirty({String value, bool requiredField}) : super.dirty(value: value, requiredField: requiredField);
  const EmailForm.pure({bool requiredField = false}) : super.pure(requiredField);

  static constructor(String value, bool requiredField) {
    return EmailForm.dirty(value: value, requiredField: requiredField);
  }

  static final RegExp _emailRegExp = RegExp(
    // r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  FieldError validator(String value) {
    var error = super.validator(value);
    if (error == null) {
      error = _emailRegExp.hasMatch(value) ? null : EmailValidationError();
    }
    return error;
  }
}
