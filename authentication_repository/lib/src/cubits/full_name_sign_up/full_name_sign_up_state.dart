part of 'full_name_sign_up_cubit.dart';

class FullNameSignUpState<T extends EmailForm, P extends PasswordForm> extends AuthState {
  factory FullNameSignUpState({
    @required String firstNameKey,
    @required String lastNameKey,
    @required String emailKey,
    @required String passwordKey,
    StringFieldForm firstName,
    StringFieldForm lastName,
    T email,
    P password,
    FormzStatus status,
    bool autoValidate,
    Function(String, bool) emailDirtyFunction,
    Function(String, bool) passwordDirtyFunction,
  }) {
    return FullNameSignUpState._(
      firstNameKey: firstNameKey,
      lastNameKey: lastNameKey,
      emailKey: emailKey,
      passwordKey: passwordKey,
      firstName: firstName ?? const StringFieldForm.pure(true),
      lastName: lastName ?? const StringFieldForm.pure(true),
      email: email ?? const EmailForm.pure(),
      password: password ?? const PasswordForm.pure(),
      status: status ?? FormzStatus.pure,
      autoValidate: autoValidate ?? false,
      emailDirtyFunction: emailDirtyFunction,
      passwordDirtyFunction: passwordDirtyFunction,
    );
  }
  FullNameSignUpState._({
    @required this.firstNameKey,
    @required this.lastNameKey,
    @required this.emailKey,
    @required this.passwordKey,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    FormzStatus status = FormzStatus.pure,
    bool autoValidate = false,
    Function(String, bool) emailDirtyFunction,
    Function(String, bool) passwordDirtyFunction,
  }) : super({
          firstNameKey: FormEntity(firstName, StringFieldForm.constructor),
          lastNameKey: FormEntity(lastName, StringFieldForm.constructor),
          emailKey: FormEntity(email, emailDirtyFunction ?? EmailForm.constructor),
          passwordKey: FormEntity(password, passwordDirtyFunction ?? PasswordForm.constructor),
        }, status, autoValidate);

  final T email;
  final String emailKey;
  final StringFieldForm firstName;
  final String firstNameKey;
  final StringFieldForm lastName;
  final String lastNameKey;
  final P password;
  final String passwordKey;

  @override
  AuthState copyWith({
    Map<String, FormEntity> forms = const {},
    FormzStatus status,
    bool autoValidate,
  }) {
    return FullNameSignUpState<T, P>(
      firstNameKey: firstNameKey,
      lastNameKey: lastNameKey,
      emailKey: emailKey,
      passwordKey: passwordKey,
      firstName: forms[firstNameKey]?.form ?? this.firstName,
      lastName: forms[lastNameKey]?.form ?? this.lastName,
      email: forms[emailKey]?.form ?? this.email,
      password: forms[passwordKey]?.form ?? this.password,
      emailDirtyFunction: forms[emailKey]?.dirtyFunc ?? this.email,
      passwordDirtyFunction: forms[passwordKey]?.dirtyFunc ?? this.password,
      status: status ?? this.status,
      autoValidate: autoValidate ?? this.autoValidate,
    );
  }
}
