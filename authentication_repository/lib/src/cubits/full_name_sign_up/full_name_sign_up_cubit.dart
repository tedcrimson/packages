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
    bool autoValidate,
    Function(String, bool) emailDirtyFunction,
    Function(String, bool) passwordDirtyFunction,
  ) : super(
            FullNameSignUpState(
              firstNameKey: firstNameKey,
              lastNameKey: lastNameKey,
              emailKey: emailKey,
              passwordKey: passwordKey,
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
      await authenticationRepository.signUp(
        fields: [state.firstName.value, state.lastName.value, state.email.value, state.password.value],
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      return true;
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
    return false;
  }
}
