import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authorization_cubit.dart';

class AuthorizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black12,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Authorization Page',
              style: TextStyle(color: Colors.yellow),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: ElevatedButton(
              child: const Text(
                'Authorize',
                style: TextStyle(fontSize: 26),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                BlocProvider.of<AuthenticationCubit>(context).authenticate();
              },
            ),
          ),
        );
      },
    );
  }
}
