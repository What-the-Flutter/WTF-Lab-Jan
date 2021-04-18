import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_chat_journal/auth_screen/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  void initState() {
    context.read<AuthCubit>().authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.isAuth) {
            Navigator.pop(context);
          } else if (!state.isAuth && state.counterAttempt != 3) {
            context.read<AuthCubit>().authenticate();
          } else if (state.counterAttempt == 3) {
            SystemNavigator.pop();
          }
          return Container();
        },
      ),
    );
  }
}
