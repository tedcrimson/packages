import 'package:authentication_repository/src/forms/field_form.dart';
import 'package:equatable/equatable.dart';

class FormEntity extends Equatable {
  FormEntity(this.form, this.dirtyFunc);

  final Function dirtyFunc;
  final FieldForm form;

  @override
  List<Object> get props => [form, dirtyFunc];

  FormEntity copyWith(FieldForm form) {
    return FormEntity(form, dirtyFunc);
  }
}
