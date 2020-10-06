import 'credential_form.dart';

enum FieldError {
  isRequired,
}

class FieldForm extends CredentialForm<FieldError> {
  const FieldForm.dirty(String value, {this.requiredField = false}) : super.dirty(value);

  static constructor(String value, bool requiredField) => FieldForm.dirty(value, requiredField: requiredField);

  const FieldForm.pure({this.requiredField = false}) : super.pure();

  final bool requiredField;

  @override
  String get errorText {
    switch (error) {
      case FieldError.isRequired:
        return 'Is Required';
    }
    return null;
  }

  @override
  FieldError validator(String value) {
    if (value == null) return null;
    return requiredField && value.isEmpty ? FieldError.isRequired : null;
  }
}
