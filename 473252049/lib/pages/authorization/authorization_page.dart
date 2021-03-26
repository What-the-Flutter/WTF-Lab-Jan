import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication_cubit/authentication_cubit.dart';

class AuthorizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Authorize'),
          onPressed: () {
            context.read<AuthenticationCubit>().authenticate();
          },
        ),
      ),
    );
  }
}
