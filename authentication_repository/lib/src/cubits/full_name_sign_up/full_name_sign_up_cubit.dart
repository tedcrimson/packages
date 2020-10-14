import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/forms.dart';
import 'package:authentication_repository/src/forms/string_form.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'full_name_sign_up_state.dart';

class FullNameSignUpCubit extends AuthCubit<FullNameSignUpState> {
  FullNameSignUpCubit(
    AuthenticationRepository repository,
    String firstNameKey,
    String lastNameKey,
    String emailKey,
    String passwordKey,
  ) : super(
            FullNameSignUpState(
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
