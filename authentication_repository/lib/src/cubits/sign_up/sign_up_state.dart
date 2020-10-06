part of 'sign_up_cubit.dart';

class SignUpState extends AuthState {
  SignUpState({
    @required this.firstNameKey,
    @required this.lastNameKey,
    @required this.emailKey,
    @required this.passwordKey,
    this.firstName = const FieldForm.pure(requiredField: true),
    this.lastName = const FieldForm.pure(requiredField: true),
    this.email = const EmailForm.pure(),
    this.password = const PasswordForm.pure(),
    FormzStatus status = FormzStatus.pure,
  }) : super({
          firstNameKey: MyForm(firstName, (x) => FieldForm.dirty(x, requiredField: true)),
          lastNameKey: MyForm(lastName, (x) => FieldForm.dirty(x, requiredField: true)),
          emailKey: MyForm(email, EmailForm.constructor),
          passwordKey: MyForm(password, PasswordForm.constructor),
        }, status);

  final EmailForm email;
  final String emailKey;
  final FieldForm firstName;
  final String firstNameKey;
  final FieldForm lastName;
  final String lastNameKey;
  final PasswordForm password;
  final String passwordKey;

  @override
  AuthState copyWith({
    Map<String, MyForm> forms = const {},
    FormzStatus status,
  }) {
    return SignUpState(
      firstNameKey: firstNameKey,
      lastNameKey: lastNameKey,
      emailKey: emailKey,
      passwordKey: passwordKey,
      firstName: forms[firstNameKey]?.form ?? this.firstName,
      lastName: forms[lastNameKey]?.form ?? this.lastName,
      email: forms[emailKey]?.form ?? this.email,
      password: forms[passwordKey]?.form ?? this.password,
      status: status ?? this.status,
    );
  }
}
