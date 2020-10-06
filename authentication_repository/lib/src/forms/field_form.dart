import 'credential_form.dart';

enum FieldError {
  isRequired,
}

class FieldForm extends CredentialForm<FieldError> {
  const FieldForm.pure({this.requiredField = false}) : super.pure();

  const FieldForm.dirty(String value, {this.requiredField = false}) : super.dirty(value);
  static constructor(String value, bool requiredField) => FieldForm.dirty(value, requiredField: requiredField);

  final bool requiredField;

  @override
  FieldError validator(String value) {
    if (value == null) return null;
    return requiredField && value.isEmpty ? FieldError.isRequired : null;
  }

  @override
  String get errorText {
    switch (error) {
      case FieldError.isRequired:
        return 'Is Required';
    }
    return null;
  }
}
