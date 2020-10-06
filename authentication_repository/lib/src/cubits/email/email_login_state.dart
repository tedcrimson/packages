part of 'email_login_cubit.dart';

class EmailLoginState extends AuthState {
  EmailLoginState({
    @required this.emailKey,
    @required this.passwordKey,
    this.email = const EmailForm.pure(),
    this.password = const PasswordForm.pure(),
    FormzStatus status = FormzStatus.pure,
  }) : super(
          {
            emailKey: MyForm(email, EmailForm.constructor),
            passwordKey: MyForm(password, PasswordForm.constructor),
          },
          status,
        );

  final EmailForm email;
  final PasswordForm password;

  final String emailKey;
  final String passwordKey;

  @override
  AuthState copyWith({
    Map<String, MyForm> forms = const {},
    FormzStatus status,
  }) {
    return EmailLoginState(
      emailKey: emailKey,
      passwordKey: passwordKey,
      email: forms[emailKey]?.form ?? this.email,
      password: forms[passwordKey]?.form ?? this.password,
      status: status ?? this.status,
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
