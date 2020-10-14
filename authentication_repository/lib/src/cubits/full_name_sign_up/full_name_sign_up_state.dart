part of 'full_name_sign_up_cubit.dart';

class FullNameSignUpState extends AuthState {
  FullNameSignUpState({
    @required this.firstNameKey,
    @required this.lastNameKey,
    @required this.emailKey,
    @required this.passwordKey,
    this.firstName = const StringFieldForm.pure(true),
    this.lastName = const StringFieldForm.pure(true),
    this.email = const EmailForm.pure(),
    this.password = const PasswordForm.pure(),
    FormzStatus status = FormzStatus.pure,
  }) : super({
          firstNameKey: FormEntity(firstName, (x) => StringFieldForm.dirty(x, true)),
          lastNameKey: FormEntity(lastName, (x) => StringFieldForm.dirty(x, true)),
          emailKey: FormEntity(email, EmailForm.constructor),
          passwordKey: FormEntity(password, PasswordForm.constructor),
        }, status);

  final EmailForm email;
  final String emailKey;
  final StringFieldForm firstName;
  final String firstNameKey;
  final StringFieldForm lastName;
  final String lastNameKey;
  final PasswordForm password;
  final String passwordKey;

  @override
  AuthState copyWith({
    Map<String, FormEntity> forms = const {},
    FormzStatus status,
  }) {
    return FullNameSignUpState(
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
