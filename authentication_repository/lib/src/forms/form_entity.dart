import 'package:equatable/equatable.dart';

import 'credential_form.dart';

class FormEntity extends Equatable {
  FormEntity(this.form, this.dirtyFunc);

  final Function dirtyFunc;
  final CredentialForm form;

  @override
  List<Object> get props => [form, dirtyFunc];

  FormEntity copyWith(CredentialForm form) {
    return FormEntity(form, dirtyFunc);
  }
}
