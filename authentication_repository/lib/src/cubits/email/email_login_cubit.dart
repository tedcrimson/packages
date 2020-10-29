import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/cubits/abstraction/auth_cubit.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:authentication_repository/src/forms.dart';

part 'email_login_state.dart';

class EmailLoginCubit extends AuthCubit<EmailLoginState> {
  EmailLoginCubit(
    AuthenticationRepository repository,
    String emailKey,
    String passwordKey,
    bool autoValidate, {
    EmailForm email,
    PasswordForm password,
    Function(String, bool) emailDirtyFunction,
    Function(String, bool) passwordDirtyFunction,
  }) : super(
            EmailLoginState(
              emailKey: emailKey,
              passwordKey: passwordKey,
              email: email,
              password: password,
              autoValidate: autoValidate,
              emailDirtyFunction: emailDirtyFunction,
              passwordDirtyFunction: passwordDirtyFunction,
            ),
            repository);

  @override
  Future<bool> callAction() async {
    if (!(await super.callAction())) return false;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      return true;
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
    return false;
  }
}
