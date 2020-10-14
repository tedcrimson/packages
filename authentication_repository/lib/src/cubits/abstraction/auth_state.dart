part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  AuthState(this.forms, this.status, this.autoValidate);

  final Map<String, FormEntity> forms;
  final FormzStatus status;
  final bool autoValidate;

  @override
  List<Object> get props => [forms.values, status];

  AuthState copyWith({
    Map<String, FormEntity> forms = const {},
    bool autoValidate,
    FormzStatus status,
  });
}
