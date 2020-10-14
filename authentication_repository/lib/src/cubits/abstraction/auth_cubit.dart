import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/forms.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'auth_state.dart';

abstract class AuthCubit<T extends AuthState> extends Cubit<T> {
  AuthCubit(AuthState state, this.authenticationRepository)
      : assert(authenticationRepository != null),
        super(state);

  final AuthenticationRepository authenticationRepository;

  // void credentialChanged(String value);

  void formChange<TT extends FieldForm>(String key, dynamic value) {
    FieldForm dirty = state.forms[key].dirtyFunc(value);
    var changes = Map<String, FormEntity>.from(state.forms);
    changes[key] = state.forms[key].copyWith(dirty);
    List<FieldForm> valid = [];
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
