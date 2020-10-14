import 'field_form.dart';

class StringFieldForm extends FieldForm<String> {
  const StringFieldForm.dirty({String value = '', bool requiredField = false}) : super.dirty(value, requiredField);

  const StringFieldForm.pure(bool requiredField) : super.pure(requiredField);
  factory StringFieldForm.constructor(String value, bool requiredField) =>
      StringFieldForm.dirty(value: value, requiredField: requiredField);

  @override
  FieldError validator(String value) {
    if (requiredField && value.isEmpty) {
      return FieldRequiredError();
    }
    return null;
  }
}
