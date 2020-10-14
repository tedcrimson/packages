import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';

import '../forms.dart';

typedef InputBuilder = Widget Function(
    BuildContext context, FieldForm form, AuthState state, ValueChanged<String> onChange);
typedef ButtonBuilder = Widget Function(
    BuildContext context, FieldForm form, AuthState state, Future<void> Function() onPressed);

abstract class LoginBuilder<T> extends StatelessWidget {
  const LoginBuilder(Key key, this.builder) : super(key: key);

  final T builder;
}
