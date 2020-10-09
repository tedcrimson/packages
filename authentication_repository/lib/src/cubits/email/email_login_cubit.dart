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
    EmailForm email,
    PasswordForm password,
  ) : super(
            EmailLoginState(
              emailKey: emailKey,
              passwordKey: passwordKey,
              email: email,
              password: password,
            ),
            repository);

  @override
  Future<void> callAction() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
