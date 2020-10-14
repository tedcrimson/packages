import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_builder.dart';

class InputField<T extends AuthCubit> extends LoginBuilder<InputBuilder> {
  InputField(ValueKey key, {InputBuilder builder}) : super(key, builder);

  @override
  Widget build(BuildContext context) {
    String keyString = (key as ValueKey).value;
    return BlocBuilder<T, AuthState>(
      // buildWhen: (previous, current) => previous.forms[keyString]?.form?.value != current.forms[keyString]?.form?.value,
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        var form = state.forms[keyString].form;
        if (builder != null) {
          return builder(context, form, state, (value) => context.bloc<T>().formChange(keyString, value));
        }
        return TextField(
          // key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.bloc<T>().formChange(keyString, email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'credential',
            helperText: '',
            errorText: form.invalid ? 'invalid credential' : null,
          ),
        );
      },
    );
  }
}
