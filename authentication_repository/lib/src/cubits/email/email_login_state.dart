part of 'email_login_cubit.dart';

class EmailLoginState extends AuthState {
  EmailLoginState({
    @required this.emailKey,
    @required this.passwordKey,
    this.email = const EmailForm.pure(),
    this.password = const PasswordForm.pure(),
    Function(String, bool) emailDirtyFunction,
    Function(String, bool) passwordDirtyFunction,
    FormzStatus status = FormzStatus.pure,
    bool autoValidate = false,
  }) : super(
          {
            emailKey: FormEntity(
              email,
              emailDirtyFunction ?? EmailForm.constructor,
            ),
            passwordKey: FormEntity(
              password,
              passwordDirtyFunction ?? PasswordForm.constructor,
            )
          },
          status,
          autoValidate,
        );

  final EmailForm email;
  final String emailKey;
  final PasswordForm password;
  final String passwordKey;
  // final Function(String, bool) emailDirtyFunction;
  // final Function(String, bool) passwordDirtyFunction;

  @override
  AuthState copyWith({
    Map<String, FormEntity> forms = const {},
    FormzStatus status,
    bool autoValidate,
  }) {
    return EmailLoginState(
      emailKey: emailKey,
      passwordKey: passwordKey,
      email: forms[emailKey]?.form ?? this.email,
      password: forms[passwordKey]?.form ?? this.password,
      emailDirtyFunction: forms[emailKey]?.dirtyFunc,
      passwordDirtyFunction: forms[passwordKey]?.dirtyFunc,
      status: status ?? this.status,
      autoValidate: autoValidate ?? this.autoValidate,
    );
  }
}

// class UsernameLoginState extends AuthState {
//   final Text userName;

//   UsernameLoginState({
//      @required String usernameKey,
//     @required String passwordKey,
//     this.userName = const Text.pure(requiredField: true),
//     Password password = const Password.pure(),
//     FormzStatus status = FormzStatus.pure,
//   }) : super([userName, password], factories, status);

//   // UsernameLoginState.forms({
//   //   List<FormzInput> forms,
//   //   FormzStatus status = FormzStatus.pure,
//   // }) : super(forms, factories, status);

//   static List<Function> factories = [
//     (String x) => Text.dirty(x, requiredField: true),
//     (String x) => Password.dirty(x),
//   ];
// }
