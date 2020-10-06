// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:pide/login/cubit/login_cubit.dart';
// import 'package:pide/login/widgets/builders.dart';

// class GoogleLoginButton extends LoginBuilder<ButtonBuilder> {
//   GoogleLoginButton(Key key,{ButtonBuilder builder}) : super(key,builder);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         if (builder != null) {
//           return builder(context, state, context.bloc<LoginCubit>().logInWithGoogle);
//         }
//         return state.status.isSubmissionInProgress
//             ? const CircularProgressIndicator()
//             : RaisedButton(
//                 // key: const Key('loginForm_googleLogin_raisedButton'),
//                 child: const Text('Google'),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//                 color: const Color(0xFFFFD600),
//                 onPressed: state.status.isValidated ? () => context.bloc<LoginCubit>().logInWithGoogle() : null,
//               );
//       },
//     );
//   }
// }
