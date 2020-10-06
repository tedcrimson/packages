part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  AuthState(this.forms, this.status);

  final Map<String, FormEntity> forms;
  final FormzStatus status;

  @override
  List<Object> get props => [forms.values, status];

  AuthState copyWith({
    Map<String, FormEntity> forms = const {},
    FormzStatus status,
  });
}
