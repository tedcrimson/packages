import 'package:formz/formz.dart';

abstract class FieldError {
  String get text;
}

class FieldRequiredError extends FieldError {
  @override
  String get text => 'field_is_required';
}

abstract class FieldForm<T> extends FormzInput<T, FieldError> {
  const FieldForm.dirty(T value, this.requiredField) : super.dirty(value);

  const FieldForm.pure(this.requiredField) : super.pure(null);

  final bool requiredField;
  String get errorText => this.pure ? null : error?.text;
}
