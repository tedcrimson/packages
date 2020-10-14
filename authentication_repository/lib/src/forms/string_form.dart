import 'field_form.dart';

class StringFieldForm extends FieldForm<String> {
  const StringFieldForm.dirty({String value, bool requiredField}) : super.dirty(value ?? '', requiredField ?? false);

  const StringFieldForm.pure(bool requiredField) : super.pure(requiredField);
  static constructor(String value, bool requiredField) =>
      StringFieldForm.dirty(value: value, requiredField: requiredField);

  @override
  FieldError validator(String value) {
    if (requiredField && value.isEmpty) {
      return FieldRequiredError();
    }
    return null;
  }
}
