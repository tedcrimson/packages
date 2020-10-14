import 'field_form.dart';

class StringFieldForm extends FieldForm<String> {
  const StringFieldForm.dirty(String value, bool requiredField) : super.dirty(value, requiredField);

  const StringFieldForm.pure(bool requiredField) : super.pure(requiredField);
  // factory StringFieldForm.constructor(String value, bool requiredField) =>
  //     StringFieldForm.dirty(value, requiredField: requiredField);

  @override
  FieldError validator(String value) {
    if (value == null && pure) return null; //TODO: aronou do something
    if (requiredField && value.isEmpty) {
      return FieldRequiredError();
    }
    return null;
  }
}
