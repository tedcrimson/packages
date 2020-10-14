import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/forms.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

part 'auth_state.dart';

abstract class AuthCubit<T extends AuthState> extends Cubit<T> {
  AuthCubit(AuthState state, this.authenticationRepository)
      : assert(authenticationRepository != null),
        super(state);

  final AuthenticationRepository authenticationRepository;

  // void credentialChanged(String value);

  void formChange<TT extends FieldForm>(String key, dynamic value) {
    var entity = state.forms[key];
    FieldForm dirty = entity.dirtyFunc(value, entity.form.requiredField);
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
    var newState = state.copyWith(
      forms: changes,
    );
    if (state.autoValidate) {
      var stat = Formz.validate(valid);

      newState = newState.copyWith(
        status: stat,
      );
    }
    emit(newState);
  }

  @mustCallSuper
  Future<bool> callAction() {
    List<FieldForm> valid = [];
    state.forms.forEach((k, value) {
      valid.add(value.form);
    });
    var status = Formz.validate(valid);
    if (status.isValid) {
      return Future.value(true);
    } else {
      emit(state.copyWith(autoValidate: true, status: FormzStatus.invalid));
      return Future.value(false);
    }
  }
}
