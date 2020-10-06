import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/forms.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'auth_state.dart';

abstract class AuthCubit<T extends AuthState> extends Cubit<T> {
  final AuthenticationRepository authenticationRepository;

  AuthCubit(AuthState state, this.authenticationRepository)
      : assert(authenticationRepository != null),
        super(state);

  // void credentialChanged(String value);

  void formChange<TT extends CredentialForm>(String key, dynamic value) {
    CredentialForm dirty = state.forms[key].dirtyFunc(value);
    var changes = Map<String, MyForm>.from(state.forms);
    changes[key] = state.forms[key].copyWith(dirty);
    List<CredentialForm> valid = [];
    state.forms.forEach((k, value) {
      if (k == key) {
        valid.add(dirty);
      } else {
        valid.add(value.form);
      }
    });
    var stat = Formz.validate(valid);
    var newState = state.copyWith(
      forms: changes,
      status: stat,
    );
    emit(newState);
  }

  Future<void> callAction();
}
