import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/forms.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends AuthCubit<SignUpState> {
  SignUpCubit(
    AuthenticationRepository repository,
    String firstNameKey,
    String lastNameKey,
    String emailKey,
    String passwordKey,
  ) : super(
            SignUpState(
              firstNameKey: firstNameKey,
              lastNameKey: lastNameKey,
              emailKey: emailKey,
              passwordKey: passwordKey,
            ),
            repository);

  @override
  Future<void> callAction() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.signUp(
        fields: [state.firstName.value, state.lastName.value, state.email.value, state.password.value],
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
