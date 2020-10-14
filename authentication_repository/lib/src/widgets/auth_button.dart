import 'package:authentication_repository/src/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'login_builder.dart';

class AuthButton<T extends AuthCubit> extends LoginBuilder<ButtonBuilder> {
  AuthButton({Key key, ButtonBuilder builder}) : super(key, builder);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (builder != null) {
          return builder(context, null, state, context.bloc<T>().callAction);
        }
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: key,
                child: const Text('Next'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: const Color(0xFFFFD600),
                onPressed: state.status.isPure || state.status.isValid ? context.bloc<T>().callAction : null,
              );
      },
    );
  }
}
