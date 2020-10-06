part of 'auth_cubit.dart';

class MyForm extends Equatable {
  final CredentialForm form;
  final Function dirtyFunc;
  MyForm(this.form, this.dirtyFunc);

  @override
  List<Object> get props => [form, dirtyFunc];

  MyForm copyWith(CredentialForm form) {
    return MyForm(form, dirtyFunc);
  }
}

abstract class AuthState extends Equatable {
  final Map<String, MyForm> forms;
  final FormzStatus status;

  AuthState(this.forms, this.status);
  @override
  List<Object> get props => [forms.values, status];

  AuthState copyWith({
    Map<String, MyForm> forms = const {},
    FormzStatus status,
  });
}
